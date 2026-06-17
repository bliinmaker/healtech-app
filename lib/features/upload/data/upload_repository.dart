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
      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Unexpected response format');
      }
      return data;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error');
    }
  }
}
