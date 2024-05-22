import 'package:dio/dio.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/voucher.dart';

Future<Response<dynamic>> sendPost(String controller, Object object) {
  var dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer ';
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json';
  return dio.post("${host}${controller}/Create", data: object);
}

Future<List<T>> fetchFromServer<T>({
  required String controller,
  required T Function(Map<String, dynamic>) fromJson,
  required ApiPagingRequest paging,
}) async {
  var dio = Dio();
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer ';
  dio.options.headers.addAll(paging.toJson());

  var response = await dio.get("$host$controller/List");
  var data = ApiPagingResponse.fromJson(response.data, fromJson);
  return data.data!;
}
