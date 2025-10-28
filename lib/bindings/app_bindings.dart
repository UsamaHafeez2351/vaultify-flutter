import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/password_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<PasswordController>(() => PasswordController());
  }
}
