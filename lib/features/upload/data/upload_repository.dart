import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class UploadRepository {
  UploadRepository() : _dio = Dio();

  static const _url = 'https://httpbin.org/post';

  final Dio _dio;

  Future<Map<String, dynamic>> uploadPhoto(XFile file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });

    try {
      final response = await _dio.post(
        _url,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error');
    }
  }
}
