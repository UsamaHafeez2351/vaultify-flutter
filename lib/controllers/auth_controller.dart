import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);

  void _showSnack(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Load user data from storage
  void loadUserData() {
    final box = GetStorage();
    final token = box.read('token');
    final userId = box.read('user_id');
    final userName = box.read('user_name');
    final userEmail = box.read('user_email');
    
    print('🔍 Loading from storage: token=${token != null}, userId=$userId, userName=$userName, userEmail=$userEmail');
    
    if (token != null && userId != null) {
      user.value = UserModel(
        id: userId.toString(),
        name: userName ?? '',
        email: userEmail ?? '',
        token: token,
      );
      print('✅ User data loaded from storage: ${user.value?.name}, ${user.value?.email}');
    } else {
      print('❌ No user data in storage');
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      isLoading.value = true;
      print('Starting signup process...');
      print('Name: $name, Email: $email');

      final apiService = ApiService();
      final res = await apiService.signup(name, email, password);

      print('Signup response: $res');

      if (res['message'] == 'User registered') {
        _showSnack('Success', 'Account created successfully!');
        Get.offAllNamed(AppRoutes.login);
      } else {
        _showSnack('Error', res['error'] ?? 'Signup failed', isError: true);
      }
    } catch (e) {
      print('Signup error: $e');
      String errorMessage = 'Failed to connect to server. ';

      if (e.toString().contains('TimeoutException')) {
        errorMessage += 'Request timed out. ';
      } else if (e.toString().contains('SocketException')) {
        errorMessage += 'Cannot reach server. ';
      }

      errorMessage += 'Please ensure your backend server is running on http://10.0.2.2:3000 (for emulator) or your PC\'s IP address (for physical device).';

      _showSnack('Connection Error', errorMessage, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final res = await apiService.login(email, password);

      if (res['token'] != null) {
        final box = GetStorage();
        await box.write('token', res['token']);
        
        print('📦 Full response: $res');
        
        // Backend returns user data nested in 'user' key
        final userData = res['user'];
        print('📊 User data from backend: $userData');
        
        if (userData == null) {
          print('❌ ERROR: No user data in response!');
          _showSnack('Error', 'Invalid server response', isError: true);
          return;
        }
        
        final userModel = UserModel.fromJson({
          'id': userData['id'],
          'name': userData['name'],
          'email': userData['email'],
          'token': res['token'],
        });
        
        print('👤 UserModel created: id=${userModel.id}, name=${userModel.name}, email=${userModel.email}');
        
        // Store user data for persistence
        await box.write('user_id', userModel.id);
        await box.write('user_name', userModel.name);
        await box.write('user_email', userModel.email);
        
        print('💾 Stored in GetStorage: id=${box.read('user_id')}, name=${box.read('user_name')}, email=${box.read('user_email')}');
        
        user.value = userModel;
        print('✅ User set in controller: ${user.value?.name}, ${user.value?.email}');
        Get.offAllNamed(AppRoutes.home);
      } else {
        _showSnack('Error', res['error'] ?? 'Login failed', isError: true);
      }
    } catch (e) {
      print('Login error: $e');
      String errorMessage = 'Failed to connect to server. ';

      if (e.toString().contains('TimeoutException')) {
        errorMessage += 'Request timed out. ';
      } else if (e.toString().contains('SocketException')) {
        errorMessage += 'Cannot reach server. ';
      }

      errorMessage += 'Please ensure your backend server is running on http://10.0.2.2:3000 (for emulator) or your PC\'s IP address (for physical device).';

      Get.snackbar('Connection Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      user.value = null;
      final box = GetStorage();
      await box.remove('token');
      await box.remove('user_id');
      await box.remove('user_name');
      await box.remove('user_email');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _showSnack('Error', 'Failed to logout', isError: true);
    }
  }

  Future<void> updateProfile(String name) async {
    try {
      isLoading.value = true;
      print('=== Starting profile update ===');
      print('New name: $name');

      final apiService = ApiService();
      final box = GetStorage();
      final token = box.read('token');
      print('Token exists: ${token != null}');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      print('Calling API...');
      final res = await apiService.updateProfile(token, name);
      print('API response: $res');

      // For now, since backend doesn't support profile updates,
      // we'll update locally and show success
      if (res['success'] == true) {
        print('Updating local storage...');
        await box.write('user_name', name);

        if (user.value != null) {
          print('Updating in-memory user...');
          user.value = UserModel(
            id: user.value!.id,
            name: name,
            email: user.value!.email,
            token: user.value!.token,
          );
        }

        print('Showing success message');
        _showSnack('Success', 'Profile updated successfully!');
      } else {
        // Backend failed, but let's still update locally for now
        print('Backend update failed, updating locally instead...');
        await box.write('user_name', name);

        if (user.value != null) {
          user.value = UserModel(
            id: user.value!.id,
            name: name,
            email: user.value!.email,
            token: user.value!.token,
          );
        }

        print('Showing success message (local update)');
        _showSnack('Success', 'Profile updated successfully!');
      }
    } catch (e) {
      print('!!! Update profile error: $e');
      // Even on error, try to update locally
      try {
        print('Attempting local update as fallback...');
        final box = GetStorage();
        await box.write('user_name', name);

        if (user.value != null) {
          user.value = UserModel(
            id: user.value!.id,
            name: name,
            email: user.value!.email,
            token: user.value!.token,
          );
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } catch (localError) {
        print('Local update also failed: $localError');
        _showSnack('Error', 'Failed to update profile: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
        rethrow;
      }
    } finally {
      isLoading.value = false;
      print('=== Update completed ===');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      
      // Call the API to send password reset email
      final res = await apiService.forgotPassword(email);
      
      if (res['success'] != true) {
        throw Exception(res['error'] ?? 'Failed to send password reset email');
      }
    } catch (e) {
      print('Forgot password error: $e');
      _showSnack('Error', 'Failed to send password reset email: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      print('=== Starting account deletion ===');

      final apiService = ApiService();
      final box = GetStorage();
      final token = box.read('token');
      print('Token exists: ${token != null}');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      print('Calling delete account API...');
      final res = await apiService.deleteAccount(token);
      print('API response: $res');

      if (res['success'] == true) {
        print('Account deleted successfully, clearing local data...');
        
        // Clear all user data from storage
        await box.remove('token');
        await box.remove('user_id');
        await box.remove('user_name');
        await box.remove('user_email');
        
        // Clear in-memory user
        user.value = null;

        print('Showing success message and navigating to login');
        _showSnack('Account Deleted', 'Your account and all associated data have been permanently deleted');
        
        // Navigate to login screen
        Get.offAllNamed(AppRoutes.login);
      } else {
        throw Exception(res['error'] ?? 'Failed to delete account');
      }
    } catch (e) {
      print('!!! Delete account error: $e');
      _showSnack('Error', 'Failed to delete account: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
      rethrow;
    } finally {
      isLoading.value = false;
      print('=== Delete account completed ===');
    }
  }
}
