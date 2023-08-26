import 'package:dio/dio.dart';

abstract class HttpService {
  void init();
  Future<Response> hitSaveMeterPicApi(String url);
  Future<Response> hitRrDetailsApi(
      String url, String rrNumber, String meterNO, String zone);
  Future<Response> hitGenerateBillApi(String url);
  Future<Response> hitPrintBillApi(String url);
  Future<Response> hitLoginApi(
    String url,
    String? userId,
    String? password,
    String? zone,
  );
}
