import 'package:dio/dio.dart';


class DioClient {
Dio gettInstance() {
return Dio(


BaseOptions(
  baseUrl: 'http://babikids.test/api/v1', // Replace with your API base URL

  connectTimeout: Duration(milliseconds: 5000),
  receiveTimeout: Duration(milliseconds: 3000),
  headers:  {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
)

 );}

}