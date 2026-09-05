import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/child/data/models/child_models.dart';
import 'voice_ai_config.dart';

/// Text-to-Speech and AI Voice synthesis service.
/// Supports smooth pause/resume, mute/unmute, and audio preloading for zero-latency story narration.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  AudioPlayer? _audioPlayer;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isPaused = false;
  bool _isMuted = false;
  VoidCallback? _onCompleteCallback;
  void Function(Duration)? _onDurationCallback;

  // Cache in-flight downloads to prevent duplicate network calls
  final Map<String, Future<File?>> _inFlightDownloads = {};

  bool get isSpeaking => _isSpeaking;
  bool get isPaused => _isPaused;
  bool get isMuted => _isMuted;

  /// Initializes audio playback and native TTS fallback engines.
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setVolume(_isMuted ? 0.0 : 1.0);
      await _audioPlayer!.setReleaseMode(ReleaseMode.stop);

      _audioPlayer!.onPlayerComplete.listen((_) {
        _isSpeaking = false;
        _isPaused = false;
        debugPrint('[TTS] Playback completed.');
        _onCompleteCallback?.call();
      });

      _audioPlayer!.onDurationChanged.listen((duration) {
        _onDurationCallback?.call(duration);
      });

      _audioPlayer!.onPlayerStateChanged.listen((state) {
        _isSpeaking = state == PlayerState.playing;
        _isPaused = state == PlayerState.paused;
      });

      _flutterTts = FlutterTts();

      if (!kIsWeb && Platform.isAndroid) {
        try {
          final engines = await _flutterTts!.getEngines;
          if (engines != null && engines is List && engines.contains('com.google.android.tts')) {
            await _flutterTts!.setEngine('com.google.android.tts');
          }
        } catch (_) {}
      }

      try {
        await _flutterTts!.setLanguage('ar-SA');
      } catch (_) {
        try {
          await _flutterTts!.setLanguage('ar');
        } catch (_) {}
      }

      await _flutterTts!.setSpeechRate(0.48);
      await _flutterTts!.setVolume(_isMuted ? 0.0 : 1.0);
      await _flutterTts!.setPitch(1.0);

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        _isPaused = false;
        _onCompleteCallback?.call();
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('[TTS] Init error: $e');
    }
  }

  /// Toggles mute state without interrupting ongoing playback or progress.
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    final vol = _isMuted ? 0.0 : 1.0;
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.setVolume(vol);
        debugPrint('[TTS] Volume set to $vol (Muted: $_isMuted)');
      } catch (_) {}
    }
    if (_flutterTts != null) {
      try {
        await _flutterTts!.setVolume(vol);
      } catch (_) {}
    }
  }

  /// Preloads all audio scenes for a given mission in the background.
  /// Priority is given to [startingSceneIndex], followed by the remaining scenes.
  Future<void> preloadMissionAudio(MissionModel mission, {int startingSceneIndex = 0}) async {
    final scenes = mission.storyScenes;
    if (scenes.isEmpty) return;

    final startIndex = startingSceneIndex.clamp(0, scenes.length - 1);
    
    // 1. Preload the first/current scene immediately
    await preloadScene(
      text: scenes[startIndex].dialogue,
      speakerName: scenes[startIndex].speakerName,
    );

    // 2. Preload remaining scenes in the background sequentially
    for (int i = 0; i < scenes.length; i++) {
      if (i == startIndex) continue;
      // Preload next scene without awaiting blocking caller
      preloadScene(
        text: scenes[i].dialogue,
        speakerName: scenes[i].speakerName,
      );
    }
  }

  /// Preloads and caches audio for a single scene dialogue.
  Future<File?> preloadScene({
    required String text,
    String speakerName = 'PORT',
  }) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return null;

    final cacheKey = '${speakerName}_$trimmedText';
    if (_inFlightDownloads.containsKey(cacheKey)) {
      return _inFlightDownloads[cacheKey];
    }

    final future = _fetchAndCacheAudio(trimmedText, speakerName);
    _inFlightDownloads[cacheKey] = future;

    try {
      final file = await future;
      return file;
    } finally {
      _inFlightDownloads.remove(cacheKey);
    }
  }

  /// Internal worker that ensures audio is saved in cache.
  Future<File?> _fetchAndCacheAudio(String trimmedText, String speakerName) async {
    // Check if already in disk cache
    final cachedFile = await _getCachedAudioFile(trimmedText, speakerName);
    if (cachedFile != null && await cachedFile.exists() && (await cachedFile.length()) > 1000) {
      return cachedFile;
    }

    // 1. ElevenLabs AI (Primary Voice Engine)
    if (VoiceAiConfig.hasElevenLabs) {
      final success = await _generateElevenLabsAudio(trimmedText, speakerName, cachedFile);
      if (success && cachedFile != null && await cachedFile.exists()) {
        return cachedFile;
      }
    }

    // 2. Fallback stream
    final fallbackCache = await _getCachedAudioFile(trimmedText, 'fallback');
    if (fallbackCache != null && await fallbackCache.exists() && (await fallbackCache.length()) > 1000) {
      return fallbackCache;
    }

    final streamed = await _generateOnlineStreamAudio(trimmedText, fallbackCache);
    if (streamed && fallbackCache != null && await fallbackCache.exists()) {
      return fallbackCache;
    }

    return null;
  }

  /// Synthesizes and narrates scene dialogue using ElevenLabs AI or cache.
  Future<void> speakScene({
    required String text,
    String speakerName = 'PORT',
    VoidCallback? onComplete,
    void Function(Duration)? onDuration,
  }) async {
    await init();
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    _onCompleteCallback = onComplete;
    _onDurationCallback = onDuration;
    _isPaused = false;

    // Ensure audio is cached (or wait for in-flight download)
    final audioFile = await preloadScene(text: trimmedText, speakerName: speakerName);
    if (audioFile != null && await audioFile.exists() && (await audioFile.length()) > 1000) {
      debugPrint('[TTS] Playing from cache: ${audioFile.path}');
      await _playAudioFile(audioFile.path);
      return;
    }

    // Native OS TTS Fallback
    await _speakViaNativeTts(trimmedText, speakerName);
  }

  /// Generates expressive Arabic speech via ElevenLabs API.
  Future<bool> _generateElevenLabsAudio(String text, String speaker, File? targetFile) async {
    try {
      final voiceId = VoiceAiConfig.activeVoiceId;
      final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId');

      debugPrint('[TTS ElevenLabs] Generating AI audio for: $text');

      final client = HttpClient();
      final request = await client.postUrl(url);
      request.headers.set('xi-api-key', VoiceAiConfig.elevenLabsApiKey.trim());
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.headers.set('Accept', 'audio/mpeg');

      final payload = jsonEncode({
        'text': text,
        'model_id': VoiceAiConfig.elevenLabsModel,
      });

      request.add(utf8.encode(payload));
      final response = await request.close();

      if (response.statusCode == 200 && targetFile != null) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        if (bytes.isNotEmpty) {
          await targetFile.writeAsBytes(bytes, flush: true);
          debugPrint('[TTS ElevenLabs] SUCCESS! Generated ${bytes.length} bytes for $speaker.');
          return true;
        }
      } else {
        final errorBody = await utf8.decodeStream(response);
        debugPrint('[TTS ElevenLabs Error ${response.statusCode}]: $errorBody');
      }
    } catch (e) {
      debugPrint('[TTS ElevenLabs] Exception: $e');
    }
    return false;
  }

  /// Online fallback stream
  Future<bool> _generateOnlineStreamAudio(String text, File? targetFile) async {
    try {
      final encodedQuery = Uri.encodeComponent(text);
      final url = 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=ar&q=$encodedQuery';
      final client = HttpClient();
      client.userAgent = 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.0.0 Mobile Safari/537.36';
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200 && targetFile != null) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        if (bytes.isNotEmpty) {
          await targetFile.writeAsBytes(bytes, flush: true);
          return true;
        }
      }
    } catch (e) {
      debugPrint('[TTS Online] Stream error: $e');
    }
    return false;
  }

  /// Plays an audio file through AudioPlayer.
  Future<void> _playAudioFile(String filePath) async {
    try {
      _isSpeaking = true;
      _isPaused = false;
      await _audioPlayer!.setVolume(_isMuted ? 0.0 : 1.0);
      await _audioPlayer!.play(DeviceFileSource(filePath), volume: _isMuted ? 0.0 : 1.0);
    } catch (e) {
      debugPrint('[TTS] Audio playback error: $e');
    }
  }

  /// Resumes playback from the exact paused position.
  Future<void> resume() async {
    if (_audioPlayer != null && _isPaused) {
      try {
        _isPaused = false;
        _isSpeaking = true;
        await _audioPlayer!.resume();
        debugPrint('[TTS] Resumed audio playback at current position.');
      } catch (e) {
        debugPrint('[TTS] Resume error: $e');
      }
    }
  }

  /// Pauses playback at the exact current position.
  Future<void> pause() async {
    _isSpeaking = false;
    _isPaused = true;
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.pause();
        debugPrint('[TTS] Paused audio playback.');
      } catch (_) {}
    }
    if (_flutterTts != null) {
      try {
        await _flutterTts!.pause();
      } catch (_) {}
    }
  }

  /// Native text-to-speech fallback.
  Future<void> _speakViaNativeTts(String text, String speaker) async {
    if (_flutterTts == null) return;
    try {
      await _flutterTts!.setPitch(1.0);
      await _flutterTts!.setSpeechRate(0.48);
      _isSpeaking = true;
      _isPaused = false;
      await _flutterTts!.setVolume(_isMuted ? 0.0 : 1.0);
      await _flutterTts!.speak(text);
    } catch (e) {
      debugPrint('[TTS] Native speak error: $e');
    }
  }

  /// Computes a cache file path for ElevenLabs George voice.
  Future<File?> _getCachedAudioFile(String text, String speaker) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final hash = 'george_$text'.hashCode.abs();
      return File('${tempDir.path}/glow_george_$hash.mp3');
    } catch (_) {
      return null;
    }
  }

  /// Stops all active audio output and resets position.
  Future<void> stop() async {
    _isSpeaking = false;
    _isPaused = false;
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.stop();
      } catch (_) {}
    }
    if (_flutterTts != null) {
      try {
        await _flutterTts!.stop();
      } catch (_) {}
    }
  }
}
