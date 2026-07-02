import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase init failed (google-services.json ausente ou inválido).
      // O app continua sem Firebase Storage — funcionalidades de upload ficarão indisponíveis.
      debugPrint('[Firebase] initializeApp falhou: $e');
    }
  }
  runApp(const ProviderScope(child: FormacaoProfessoresApp()));
}
