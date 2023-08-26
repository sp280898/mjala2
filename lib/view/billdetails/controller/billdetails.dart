import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mjala/models/getprintbilldata.dart';

import '../../../utils/toastmessage.dart';

class BillPrintController extends GetxController {
  List details = <PrintBillDetails>[].obs;
  RxBool isLoading = false.obs;
  Future getPrintBillApi(
      {required String url,
      required String rrnumber,
      required String meterNo,
      required String zone}) async {
    Map body = {'rrnumber': rrnumber, "meterno": meterNo, 'zone': zone};
    try {
      print(rrnumber);
      print(zone);
      details.clear();
      isLoading(true);
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: _setHeaders(),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        details.clear();
        details = jsonDecode(response.body.toString());
        // print(details);
        Utils().showToast('Done');
        isLoading(false);
        return details;
      } else {
        isLoading(false);
        Get.snackbar(
            'Failed to Fetch data', 'Something went wrong!\nTry Again');
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }

  _setHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
