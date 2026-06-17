import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../data/upload_repository.dart';
import 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit(this._repository) : super(UploadInitial());

  final UploadRepository _repository;
  final _picker = ImagePicker();

  Future<void> pickPhoto() => _pickImage(ImageSource.gallery);
  Future<void> takePhoto() => _pickImage(ImageSource.camera);

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file != null) emit(UploadPhotoSelected(file));
  }

  Future<void> upload() async {
    final file = switch (state) {
      UploadPhotoSelected s => s.file,
      UploadError s => s.file,
      _ => null,
    };
    if (file == null) return;

    emit(UploadLoading(file));
    try {
      final data = await _repository.uploadPhoto(file);
      emit(UploadSuccess(file: file, data: data));
    } catch (e) {
      emit(UploadError(file: file, message: e.toString()));
    }
  }

  void reset() => emit(UploadInitial());
}
