class AppConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const String apiDocsUrl = '$baseUrl/api/docs';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String firebaseStorageBucket = 'midiasave-5c064.firebasestorage.app';
  static const String storageBasePath = 'formacao-professores';
}
