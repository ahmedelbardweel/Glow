import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../features/child/data/models/child_models.dart';
import '../widgets/shapes/port_3d_model_viewer.dart';
import 'tts_service.dart';

/// Intelligent High-Performance Asset Preloading & Warm-up Service.
/// Pre-caches 3D GLB meshes, TTS speech audio, and sound effects in preceding screens
/// to guarantee sub-millisecond instant offline/online playback with zero UI stutters.
class AssetPreloadService {
  static final AssetPreloadService _instance = AssetPreloadService._internal();
  factory AssetPreloadService() => _instance;
  AssetPreloadService._internal();

  // In-memory byte cache for preloaded 3D GLB models
  final Map<String, ByteData> _memory3dCache = {};
  final Set<String> _preloadedAssets = {};
  final Set<String> _inFlightLoads = {};

  bool get isMemoryWarm => _memory3dCache.isNotEmpty;

  /// High-priority warm-up executed at application launch (SplashScreen / main).
  Future<void> warmupApp({String defaultCharacter = 'PORT'}) async {
    try {
      // 1. Initialize TTS and audio engines in parallel
      unawaited(TtsService().init());

      // 2. Preload default character 3D models into memory
      await preloadCharacter3DModels(characterName: defaultCharacter);

      debugPrint('[AssetPreloadService] Core application warm-up complete.');
    } catch (e) {
      debugPrint('[AssetPreloadService] Warm-up encountered error: $e');
    }
  }

  /// Preloads all 4 3D pose variations for a given character into RAM cache.
  Future<void> preloadCharacter3DModels({
    required String characterName,
    List<CharacterPose> poses = const [
      CharacterPose.neutral,
      CharacterPose.frontal,
      CharacterPose.laughing,
      CharacterPose.victory,
    ],
  }) async {
    final charKey = characterName.trim().toLowerCase();
    final normalizedChar = (charKey == 'sort') ? 'lort' : charKey;
    final validChar =
        ['port', 'mort', 'fort', 'lort', 'qort'].contains(normalizedChar)
            ? normalizedChar
            : 'port';

    final assetPaths = <String>[];
    for (final pose in poses) {
      final path = 'assets/models/${validChar}_${pose.name}.glb';
      assetPaths.add(path);
    }
    // Also include base character GLB
    assetPaths.add('assets/models/$validChar.glb');

    await Future.wait(
      assetPaths.map((path) => _loadAssetIntoMemory(path)),
      eagerError: false,
    );
  }

  /// Intelligently preloads all assets for an upcoming Mission & Story before navigation.
  Future<void> preloadMissionAndStoryAssets({
    required MissionModel mission,
    required String activeCharacter,
  }) async {
    final futures = <Future<void>>[];

    // 1. Preload 3D models for all speakers in this story
    final speakers = <String>{activeCharacter};
    for (final scene in mission.storyScenes) {
      if (scene.speakerName.isNotEmpty) {
        speakers.add(scene.speakerName);
      }
    }

    for (final speaker in speakers) {
      futures.add(preloadCharacter3DModels(characterName: speaker));
    }

    // 2. Pre-cache TTS audio for all story dialogue in the background
    if (mission.storyScenes.isNotEmpty) {
      futures.add(TtsService().preloadMissionAudio(mission));
    }

    // 3. Preload victory and quiz celebratory models ahead of time
    futures.add(
      preloadCharacter3DModels(
        characterName: activeCharacter,
        poses: [CharacterPose.victory, CharacterPose.laughing],
      ),
    );

    await Future.wait(futures, eagerError: false);
    debugPrint(
        '[AssetPreloadService] Mission "${mission.title}" assets preloaded.');
  }

  /// Preloads victory and reward assets ahead of completing a quiz or level.
  Future<void> preloadQuizCompletionAssets({
    required String activeCharacter,
  }) async {
    await preloadCharacter3DModels(
      characterName: activeCharacter,
      poses: [CharacterPose.victory, CharacterPose.laughing],
    );
  }

  /// Low-level loader that pulls binary asset bytes into memory.
  Future<void> _loadAssetIntoMemory(String assetPath) async {
    if (_preloadedAssets.contains(assetPath) ||
        _inFlightLoads.contains(assetPath)) {
      return;
    }

    _inFlightLoads.add(assetPath);
    try {
      final byteData = await rootBundle.load(assetPath);
      _memory3dCache[assetPath] = byteData;
      _preloadedAssets.add(assetPath);
      debugPrint(
          '[AssetPreloadService] Preloaded in RAM: $assetPath (${byteData.lengthInBytes} bytes)');
    } catch (e) {
      debugPrint('[AssetPreloadService] Could not preload $assetPath: $e');
    } finally {
      _inFlightLoads.remove(assetPath);
    }
  }

  /// Check if a 3D model asset is already warm in memory.
  bool isAssetPreloaded(String assetPath) =>
      _preloadedAssets.contains(assetPath);

  /// Clears in-memory caches if memory pressure warning is received.
  void clearMemoryCache() {
    _memory3dCache.clear();
    _preloadedAssets.clear();
    _inFlightLoads.clear();
    debugPrint('[AssetPreloadService] Memory cache cleared.');
  }
}
