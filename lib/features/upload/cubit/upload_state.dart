import 'package:image_picker/image_picker.dart';

sealed class UploadState {}

class UploadInitial extends UploadState {}

class UploadPhotoSelected extends UploadState {
  UploadPhotoSelected(this.file);
  final XFile file;
}

class UploadLoading extends UploadState {
  UploadLoading(this.file);
  final XFile file;
}

class UploadSuccess extends UploadState {
  UploadSuccess({required this.file, required this.data});
  final XFile file;
  final Map<String, dynamic> data;
}

class UploadError extends UploadState {
  UploadError({required this.file, required this.message});
  final XFile file;
  final String message;
}