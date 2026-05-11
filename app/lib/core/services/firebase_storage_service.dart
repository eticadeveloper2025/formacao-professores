import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});

class FirebaseStorageService {
  FirebaseStorage? get _storage => kIsWeb ? null : FirebaseStorage.instance;

  /// Faz upload de uma mídia para o Firebase Storage
  /// Caminho: formacao-professores/{folder}/{userId}/{timestamp}_{uuid4hex}.{ext}
  Future<String> uploadMidia({
    required File file,
    required String folder,
    required int userId,
    required String contentType,
    Function(double)? onProgress,
  }) async {
    if (_storage == null) {
      throw UnsupportedError('Firebase Storage não disponível na web');
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uuid4hex = const Uuid().v4().replaceAll('-', '').substring(0, 4);
    final ext = contentType.contains('image') ? 'jpg' : 'mp4';
    final fileName = '${timestamp}_$uuid4hex.$ext';
    final path = 'formacao-professores/$folder/$userId/$fileName';

    final ref = _storage!.ref().child(path);
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: contentType),
    );

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((event) {
        final progress = event.bytesTransferred / event.totalBytes;
        onProgress(progress);
      });
    }

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Remove mídia pelo URL (limpeza de mídia órfã)
  Future<void> removerMidia(String url) async {
    if (_storage == null) return;
    try {
      final ref = _storage!.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Arquivo pode já ter sido removido
      debugPrint('Erro ao remover mídia: $e');
    }
  }

  /// Obtém URL de download de um arquivo do Storage
  Future<String> getDownloadUrl(String path) async {
    if (_storage == null) {
      throw UnsupportedError('Firebase Storage não disponível na web');
    }
    final ref = _storage!.ref().child(path);
    return await ref.getDownloadURL();
  }
}
