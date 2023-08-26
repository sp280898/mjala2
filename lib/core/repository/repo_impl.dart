import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mjala/app_url/app_url.dart';
import 'package:mjala/core/repository/repo.dart';
import 'package:mjala/models/detailsdata.dart';
import 'package:mjala/models/generatebilldata.dart';
import 'package:mjala/models/getprintbilldata.dart';
import 'package:mjala/models/logindata.dart';
import 'package:mjala/models/savemeterpicdata.dart';

import '../../services/http_service.dart';
import '../../services/http_service_impl.dart';

class RepoImpl implements Repo {
  late HttpService _httpService;

  RepoImpl() {
    _httpService = Get.put(HttpServiceImpl());
    _httpService.init();
  }

  // @override
  // hitLoginApi(String phone, String token) {
  //   // TODO: implement hitLoginApi
  //   throw UnimplementedError();
  // }

  @override
  Future<Generatebilldata?> hitGenerateBillApi() {
    // TODO: implement hitGenerateBillApi
    throw UnimplementedError();
  }

  @override
  Future<LoginData?> hitLoginApi(
    String? userId,
    String? password,
    String? zone,
  ) async {
    var parsedResponse;
    try {
      final response = await _httpService.hitLoginApi(
        AppUrls.loginApi,
        userId,
        password,
        zone,
      );
      for (var i in response.data) {
        parsedResponse = LoginData.fromJson(i);
      }
      return parsedResponse;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw UnimplementedError();
    }
  }

  @override
  Future<PrintBillDetails?> hitPrintBillApi() {
    // TODO: implement hitPrintBillApi
    throw UnimplementedError();
  }

  @override
  Future<DetailsData?> hitRrDetailsApi(
      String rrNumber, String meterNO, String zone) async {
    try {
      final response = await _httpService.hitRrDetailsApi(
          AppUrls.rrApi, rrNumber, meterNO, zone);
      final parsedResponse = DetailsData.fromJson(response.data);
      return parsedResponse;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw UnimplementedError();
    }
  }

  @override
  Future<Savemeterpicdata?> hitSaveMeterPicApi() {
    // TODO: implement hitSaveMeterPicApi
    throw UnimplementedError();
  }
}
