/// Configuration for AI Voice synthesis engines (ElevenLabs and OpenAI) in Flutter.
class VoiceAiConfig {
  VoiceAiConfig._();

  /// ElevenLabs API Key
  static String elevenLabsApiKey = 'sk_34fa42d81572dcd5af366d135d68e5e47d6cf250e8a5da20';

  /// ElevenLabs Model ID (Multilingual v2 has expressive Arabic support)
  static const String elevenLabsModel = 'eleven_multilingual_v2';

  /// ElevenLabs Voice ID (George - Verified working 100% with Arabic storytelling)
  static const String activeVoiceId = 'JBFqnCBsd6RMkjVDRZzb';

  /// ElevenLabs Voice IDs mapped to GLOW cartoon characters
  static const Map<String, String> characterVoiceIds = {
    'PORT': 'JBFqnCBsd6RMkjVDRZzb', // George (Expressive Arabic Storyteller)
    'MORT': 'JBFqnCBsd6RMkjVDRZzb',
    'FORT': 'JBFqnCBsd6RMkjVDRZzb',
    'QORT': 'JBFqnCBsd6RMkjVDRZzb',
    'LORT': 'JBFqnCBsd6RMkjVDRZzb',
  };

  /// OpenAI API Key fallback
  static String openAiApiKey = '';

  /// OpenAI Voice mappings
  static const Map<String, String> openAiVoiceMap = {
    'PORT': 'nova',
    'MORT': 'echo',
    'FORT': 'alloy',
    'QORT': 'shimmer',
    'LORT': 'fable',
  };

  /// Returns true if an ElevenLabs API key is configured.
  static bool get hasElevenLabs => elevenLabsApiKey.trim().isNotEmpty;

  /// Returns true if an OpenAI API key is configured.
  static bool get hasOpenAi => openAiApiKey.trim().isNotEmpty;
}
