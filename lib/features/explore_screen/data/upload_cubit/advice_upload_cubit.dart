import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:http/http.dart' as http;
part 'advice_upload_state.dart';

/// ----------------------
/// AdviceUploadCubit
/// ----------------------
class AdviceUploadCubit extends Cubit<AdviceUploadState> {
  AdviceUploadCubit() : super(AdviceUploadState.initial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadAdvice({
    required String title,
    required String content,
    required String mediaType,
    required String author,
    required String authorId,
    required String category,
    File? mediaFile,
  }) async {
    emit(AdviceUploadState.loading());
    try {
      String? mediaUrl;
      if (mediaType != 'Text' && mediaFile != null) {
        final uri = Uri.parse('http://${APIs.baseServerUrl}/upload');
        final request = http.MultipartRequest('POST', uri);
        // Add the file (and optionally, uid) to the request.
        request.files.add(
          await http.MultipartFile.fromPath('file', mediaFile.path),
        );
        // Optionally, add uid to the form fields:
        // request.fields['uid'] = 'specialist_uid_here';
        final response = await request.send();
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          final jsonResponse = jsonDecode(respStr);
          // The server now returns an encrypted token under "encrypted_url"
          mediaUrl = jsonResponse['encrypted_url'];
        } else {
          throw Exception('Failed to upload media to the local server');
        }
      }
      ;
      // Save advice details to Firestore with the encrypted media token.
      await firestore.collection('advices').add({
        'title': title,
        'content': content,
        'type': mediaType, 
        'mediaUrl': mediaUrl,
        'author': author,
        'authorId': authorId,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(AdviceUploadState.success());
    } catch (e) {
      emit(AdviceUploadState.error(e.toString()));
    }
  }
}
