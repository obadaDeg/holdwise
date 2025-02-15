import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
part 'advice_upload_state.dart';

/// ----------------------
/// AdviceUploadCubit
/// ----------------------
class AdviceUploadCubit extends Cubit<AdviceUploadState> {
  AdviceUploadCubit() : super(AdviceUploadState.initial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Replace with your secure key (32 characters for AES-256) and IV.
  // In a real app, store these securely.
  final String _secretKey = '32characterslongsecretkey1234567890';
  final encrypt.IV _iv = encrypt.IV.fromLength(16);

  /// Encrypts the file URL using AES.
  String _encryptFilePath(String filePath) {
    final key = encrypt.Key.fromUtf8(_secretKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(filePath, iv: _iv);
    return encrypted.base64;
  }

  /// Optionally, a method to decrypt the file path.
  String decryptFilePath(String encryptedPath) {
    final key = encrypt.Key.fromUtf8(_secretKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedPath, iv: _iv);
    return decrypted;
  }

  Future<void> uploadAdvice({
    required String title,
    required String content,
    required String mediaType,
    File? mediaFile,
  }) async {
    emit(AdviceUploadState.loading());
    try {
      String? mediaUrl;
      if (mediaType != 'Text' && mediaFile != null) {
        final uri = Uri.parse('http://172.29.224.1:5000/upload');
        final request = http.MultipartRequest('POST', uri);
        // Add the file and uid (if needed) to the request.
        request.files.add(
          await http.MultipartFile.fromPath('file', mediaFile.path),
        );
        // Optionally, you can add uid to the form.
        // request.fields['uid'] = 'specialist_uid_here';
        final response = await request.send();
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          final jsonResponse = jsonDecode(respStr);
          // The server returns the plain URL.
          String plainUrl = jsonResponse['url'];
          // Encrypt the file URL before storing it.
          mediaUrl = _encryptFilePath(plainUrl);
        } else {
          throw Exception('Failed to upload media to the local server');
        }
      }
      
      // Save advice details to Firestore with the encrypted media URL.
      await firestore.collection('advices').add({
        'title': title,
        'content': content,
        'mediaType': mediaType,
        'mediaUrl': mediaUrl, // This is now encrypted.
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(AdviceUploadState.success());
    } catch (e) {
      emit(AdviceUploadState.error(e.toString()));
    }
  }
}
