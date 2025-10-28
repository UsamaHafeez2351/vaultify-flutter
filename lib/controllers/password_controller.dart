import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/password_model.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';

class PasswordController extends GetxController {
  var passwords = <PasswordModel>[].obs;
  var isLoading = false.obs;
  final ApiService _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchPasswords();
  }

  // Fetch all passwords
  Future<void> fetchPasswords() async {
    try {
      isLoading.value = true;
      final box = GetStorage();
      final token = box.read('token');
      final data = await _api.getPasswords(token: token);
      passwords.value = data;
    } catch (e) {
      Helpers.showSnack("Error", "Failed to load passwords", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Add new password
  Future<void> addPassword(String title, String username, String password) async {
    try {
      final box = GetStorage();
      final token = box.read('token');
      final passwordModel = PasswordModel(title: title, username: username, password: password);
      final createdPassword = await _api.addPassword(passwordModel, token: token);
      passwords.add(createdPassword);
      Helpers.showSnack("Success", "Password added successfully!");
    } catch (e) {
      Helpers.showSnack("Error", "Failed to add password", isError: true);
    }
  }

  // Update existing password
  Future<void> updatePassword(int id, String title, String username, String password) async {
    try {
      final box = GetStorage();
      final token = box.read('token');
      final passwordModel = PasswordModel(id: id, title: title, username: username, password: password);
      final updatedPassword = await _api.updatePassword(passwordModel, token: token);

      // Update the password in the list with the returned object (which has all metadata)
      int index = passwords.indexWhere((p) => p.id == id);
      if (index != -1) {
        passwords[index] = updatedPassword;
        passwords.refresh();
      }

      Helpers.showSnack("Updated", "Password updated successfully!");
    } catch (e) {
      Helpers.showSnack("Error", "Failed to update password", isError: true);
    }
  }

  // Delete password
  Future<void> deletePassword(int id) async {
    try {
      final box = GetStorage();
      final token = box.read('token');
      await _api.deletePassword(id, token: token);
      passwords.removeWhere((p) => p.id == id);
      Helpers.showSnack("Deleted", "Password deleted successfully!");
    } catch (e) {
      Helpers.showSnack("Error", "Failed to delete password", isError: true);
    }
  }
}
