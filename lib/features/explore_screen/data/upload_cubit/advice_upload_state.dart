part of 'advice_upload_cubit.dart';

enum AdviceUploadStatus { initial, loading, success, error }

// State class for AdviceUploadCubit.
class AdviceUploadState {
  final AdviceUploadStatus status;
  final String? errorMessage;
  
  AdviceUploadState({required this.status, this.errorMessage});
  
  factory AdviceUploadState.initial() =>
      AdviceUploadState(status: AdviceUploadStatus.initial);
  factory AdviceUploadState.loading() =>
      AdviceUploadState(status: AdviceUploadStatus.loading);
  factory AdviceUploadState.success() =>
      AdviceUploadState(status: AdviceUploadStatus.success);
  factory AdviceUploadState.error(String message) =>
      AdviceUploadState(status: AdviceUploadStatus.error, errorMessage: message);
}