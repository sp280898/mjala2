import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mjala/core/repository/repo.dart';
import 'package:mjala/core/repository/repo_impl.dart';
import 'package:mjala/utils/toastmessage.dart';
import '../../../models/detailsdata.dart';

class GetrrnumberController extends GetxController {
  RxBool isLoading = false.obs;
  var rrDetails = <DetailsData>[].obs;
  // final client = http.Client();
  Repo? _repo;

  GetrrnumberController() {
    _repo = Get.find<RepoImpl>();
  }
  Future getRRApi({
    String? rrnumber,
    String? meterNo,
    String? zone,
  }) async {
    // Map body = {"rrnumber": rrnumber, "meterno": meterNo, "zone": zone};
    try {
      rrDetails.clear();
      isLoading(true);

      rrDetails.value = (await _repo!.hitRrDetailsApi(rrnumber!, meterNo!, zone!)) as List<DetailsData>;

      // if (response.statusCode == 200) {
      rrDetails.clear();
      // rrDetails = jsonDecode(response.body.toString());

      // print(rrDetails.toString());
      Utils().showToast('Done');
      isLoading(false);

      // return rrDetails;
      // } else if (response.statusCode == 500) {
      // rrDetails.clear();
      // isLoading(false);
      // throw Exception('Data is not Available for this RRnumber ');
      // }
      //else {
      //   rrDetails.clear();
      //   isLoading(false);
      //   Utils().showToast(response.toString());
      // }
    } catch (e) {
      rrDetails.clear();
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }

  _setHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};
}
