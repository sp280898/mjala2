import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'http_service.dart';

const BASE_URL = "https://skrocare.com/hawari/public/";

class HttpServiceImpl implements HttpService {
  late Dio _dio;

  initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(onError: (error, handler) {
        if (kDebugMode) {
          print(error.message);
        }
        return handler.next(error);
      }, onRequest: (request, handler) {
        if (kDebugMode) {
          print('${request.method} | ${request.path} | ${request.data}');
        }
        return handler.next(request);
      }, onResponse: (response, handler) {
        if (kDebugMode) {
          print(
              "${response.statusCode} | ${response.statusMessage} | ${response.data}");
        }
        return handler.next(response);
      }),
    );
  }

  @override
  void init() {
    // TODO: implement init
    _dio = Dio(BaseOptions(baseUrl: BASE_URL));
    initializeInterceptors();
  }

  @override
  Future<Response> hitProfileApi(String url, String userId) async {
    // TODO: implement hitProfileApi
    Response response;
    try {
      response = await _dio.post(url, data: {
        'userId': userId,
      });
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> hitTopsellerApi(String url) async {
    // TODO: implement hitTopsellerApi
    Response response;
    try {
      response = await _dio.post(url);
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> hitSearchApi(String url, String search) async {
    // TODO: implement hitSearchApi
    Response response;
    try {
      response = await _dio.post(url, data: {
        'search': search,
      });
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> hitEnquiryproductApi(
      String url,
      String productName,
      String productId,
      String quantity,
      String userName,
      String userEmail,
      String mobile,
      String state,
      String userId) async {
    // TODO: implement hitEnquiryproductApi
    Response response;
    try {
      response = await _dio.post(url, data: {
        'product_name': productName,
        'quantity': quantity,
        'user_name': userName,
        'user_email': userEmail,
        'mobile': mobile,
        'state': state,
        'user_id': userId,
      });
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> hitGenerateBillApi(
    String url,
  ) {
    // TODO: implement hitGenerateBillApi
    throw UnimplementedError();
  }

  @override
  Future<Response> hitLoginApi(
    String url,
    String? userId,
    String? password,
    String? zone,
  ) async {
    Response response;
    try {
      response = await _dio.post(url,
          data: {'userid': userId, 'password': password, 'zone': zone});
    } on DioException catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> hitPrintBillApi(
    String url,
  ) {
    // TODO: implement hitPrintBillApi
    throw UnimplementedError();
  }

  @override
  Future<Response> hitRrDetailsApi(
    String url,
    String rrNumber,
    String meterNO,
    String zone,
  ) async {
    Response response;
    try {
      response = await _dio.post(url,
          data: {"rrnumber": rrNumber, "meterno": meterNO, "zone": zone});
    } on DioException catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  @override
  Future<Response> hitSaveMeterPicApi(
    String url,
  ) {
    // TODO: implement hitSaveMeterPicApi
    throw UnimplementedError();
  }
}
