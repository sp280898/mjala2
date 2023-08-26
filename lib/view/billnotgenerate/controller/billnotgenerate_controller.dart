import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mjala/utils/toastmessage.dart';

class BillNotGenerateController extends GetxController {
  // Map details = {};
  dynamic data;
  RxBool isLoading = false.obs;
  Future generateBillApi({
    required String url,
    required String rrNumber,
    required String sdId,
    required String mrId,
    required String readingDay,
    required String userId,
    required String zoneName,
    required String presentReading,
    // required String reasonId,
    String? clubbedNumber,
  }) async {
    Map body = {
      "xmldata":
          "<READINGTABLE><READINGS RRNUMBER='$rrNumber' PRESENTREADING='$presentReading' REASONID='' CLUBBEDMRRNUMBER=''/></READINGTABLE>",
      "rrnumber": "$rrNumber",
      "sdid": sdId,
      "mrid": mrId,
      "readingday": readingDay,
      "userid": userId,
      "zone": zoneName
    };
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _setHeaders(),
      );
      data = jsonDecode(response.body.toString());
      // print(body);
      if (response.statusCode == 200) {
        // print("data:${data.toString()}");
        if (data.contains(
            "A column named 'msg' already belongs to this DataTable")) {
          Get.snackbar('Bill Already Generated', 'Print Bill');
        } else {
          Get.snackbar('Successfully Bill Generated', '');
        }
      } else {
        isLoading(false);
        Get.snackbar('Failed to Generate Bill',
            'Something went wrong!\nPlease Try Again');
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }

  _setHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
