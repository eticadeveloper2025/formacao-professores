class AppConfig {
  // Set via --dart-define=API_BASE_URL=https://your-api.onrender.com at build time.
  // Default points to the production Render API (override with --dart-define for local dev).
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://formacao-professores-api.onrender.com',
  );
  static const String apiDocsUrl = '$baseUrl/api/docs';
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String firebaseStorageBucket = 'midiasave-5c064.firebasestorage.app';
  static const String storageBasePath = 'formacao-professores';
}
