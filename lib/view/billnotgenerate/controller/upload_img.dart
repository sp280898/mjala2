import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UploadImage extends GetxController {
  Map details = {}.obs;
  RxBool isLoading = false.obs;
  RxBool isDone = true.obs;

  // @override
  // void onInit() {
  //   // ever
  //   super.onInit();
  //   once(isDone, (_) => print("call :${isDone.value}"));
  // }

  Future uploadImageApi({
    required String url,
    required String imgValue,
    required String rrNumber,
    required String meterNo,
    required String zone,
    // required String lat,
    // required String long,
  }) async {
    Map body = {
      'ImgValue': imgValue,
      'meterno': meterNo,
      'rrnumber': rrNumber,
      'zone': zone,
      // 'lat': lat,
      // 'long': long
    };

    try {
      isLoading(true);
      isDone(true);
      final response = await  http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _setHeaders(),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(
          response.body.toString(),
        );
        for (var i in data) {
          details.addAll(i);
        }
        if (details['status'] == 'Success' &&
            details['msg'] == 'Image inserted successfully') {
          isLoading(false);
          isDone(false);
          Get.snackbar(
              'Successfully ✅', "Image Uploaded Successfully to server");
        } else if (details['status'] == 'Failure' ||
            details['msg'] == 'Image insertion failed') {
          isLoading(false);
          isDone.value = false;
          Get.snackbar('Meter Image Already Uploaded', "");
        }
        isDone(false);
      } else {
        isDone(false);
        isLoading(false);
        Get.snackbar('Error', 'Something went wrong!\nTry Again');
      }
    } catch (e) {
      isDone(false);
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
    return details;
  }

  _setHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
