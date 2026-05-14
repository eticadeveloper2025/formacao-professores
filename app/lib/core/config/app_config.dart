class AppConfig {
  // Set via --dart-define=API_BASE_URL=https://your-api.onrender.com at build time.
  // Default falls back to localhost for local dev.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const String apiDocsUrl = '$baseUrl/api/docs';
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String firebaseStorageBucket = 'midiasave-5c064.firebasestorage.app';
  static const String storageBasePath = 'formacao-professores';
}
