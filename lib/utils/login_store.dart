import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyPref {
  // static init() async{
  // aw  GetStorage.init();
  // }

  final box = GetStorage();

  void saveLogin(String userId, String password, bool status) {
    box.write('userId', userId);
    box.write('password', password);
    box.write('status', status);
  }

  void skipLogin() {
    final username = box.read('userId');
    final userpass = box.read('password');
    if (username != null && userpass != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  void saveData({
    String? zoneNumber,
    String? sdid,
    String? userName,
    String? zoneName,
  }) {
    box.write('zoneNumber', zoneNumber);
    box.write('zoneName', zoneName);
    box.write('sdid', sdid);
    box.write('userName', userName);
  }
}
