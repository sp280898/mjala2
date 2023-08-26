import 'dart:convert';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mjala/app_url/app_url.dart';
import 'package:mjala/core/repository/repo.dart';
import 'package:mjala/core/repository/repo_impl.dart';
import '../../../models/logindata.dart';
import '../../../utils/login_store.dart';

class LoginController extends GetxController {
  Repo? _repo;
  MyPref myPref = MyPref();

  RxBool isLoading = false.obs;

  LoginController() {
    _repo = Get.put<RepoImpl>(RepoImpl());
  }
  LoginData? loginData;

  void postLoginApi({
    String? userId,
    String? password,
    String? zone,
  }) async {
    isLoading(true);

    try {
      loginData = await _repo!.hitLoginApi(userId, password, zone);

      if (loginData != null) {
        print('result : $loginData');
        //   var body = jsonDecode(result.toString());

        //   // List<LoginModel> loginModels = [];

        //   for (var i in body) {
        //     loginData = LoginData.fromJson(i);
        //     // loginModels.add(model);
      }

      // for (var loginModel in loginModels) {
      // if (loginModel.loginData != null &&
      // loginModel.loginData!.isNotEmpty) {

      // Perform your logic here using zoneNumber, status, and other data...
      bool status = loginData!.logStatus!;
      if (loginData!.msg == 'Success' || status == true) {
        String zoneNumber = loginData!.zone.toString();
        String sdid = loginData!.sdid.toString();
        MyPref().saveLogin(userId.toString(), password.toString(), status);
        MyPref().saveData(
            zoneNumber: zoneNumber,
            sdid: sdid,
            userName: userId,
            zoneName: zone);
        Get.offAllNamed('/home');
        isLoading(false);

        Get.snackbar('Successful', 'Welcome');
      } else if (loginData!.msg == 'Failure' && loginData!.logStatus == false) {
        isLoading(false);
        Get.snackbar('Wrong Credentials', 'Enter valid userId and password');
      } else {
        isLoading(false);
        // Get.snackbar('Something wrong', res.statusCode.toString());
      }
      // } else {
      //   isLoading(false);
      //   // Get.snackbar('Something went wrong', res.statusCode.toString());
      // }
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        'Something went wrong',
        e.toString(),
      );
    }

    _setHeaders() =>
        {'Content-type': 'application/json', 'Accept': 'application/json'};
  }
}
