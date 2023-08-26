import 'package:get/get.dart';
import 'package:mjala/core/repository/repo_impl.dart';
import 'package:mjala/view/auth/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(() => RepoImpl());
    Get.lazyPut(() => LoginController());
  }
}
