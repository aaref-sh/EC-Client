import 'package:dio/dio.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/voucher.dart';

Future<Response<dynamic>> sendPost<T>(String controller, T object,
    {String action = "Create"}) {
  var dio = Dio();
  dio.options.headers['Aut`horization'] = 'Bearer $token';
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json; charset=utf-8';
  return dio.post("$host$controller/$action", data: object);
}

Future<List<T>> fetchFromServer<T>(
    {required String controller,
    required T Function(Map<String, dynamic>) fromJson,
    ApiRequest? headers,
    String action = "List"}) async {
  var dio = Dio();
  dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';
  dio.options.headers['Accept'] = 'application/json; charset=utf-8';
  dio.options.headers['Authorization'] = 'Bearer ';

  var response = await dio.get("$host$controller/$action",
      queryParameters: headers?.toJson());
  var data = ApiPagingResponse.fromJson(response.data, fromJson);
  return data.data!;
}

Future<Response<dynamic>> sendPut<T>(String controller, dynamic object) {
  var dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json; charset=utf-8';

  return dio.put("$host$controller/Update/${object.id}", data: object);
}
