import 'package:cric/core/api_endpoints.dart';
import 'package:cric/features/login/data/datasources/login_remote_datasource.dart';
import 'package:dio/dio.dart';

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSourceImpl(this.dio);

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        //  'https://reqres.in/api/login'
        "${ApiEndpoints.baseUrl}${ApiEndpoints.login}",
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'x-api-key': 'reqres-free-v1',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Success
      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'];
      } else {
        throw Exception('Unexpected response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data['error'] != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
