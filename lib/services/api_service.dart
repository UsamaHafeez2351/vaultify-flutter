import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/password_model.dart';
import '../utils/constants.dart';

class ApiService {
  final String base = baseUrl; // from constants.dart

  // Helper to build headers (include token if provided)
  Map<String, String> _headers([String? token]) {
    final h = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      // If your backend expects "Authorization: Bearer <token>"
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  // Fetch all passwords -> returns List<PasswordModel>
  Future<List<PasswordModel>> getPasswords({String? token}) async {
    final uri = Uri.parse('$base/passwords');
    final res = await http.get(uri, headers: _headers(token));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      // backend might return an array or object; handle both.
      if (body is List) {
        return body.map<PasswordModel>((e) => PasswordModel.fromJson(e)).toList();
      } else if (body is Map && body['passwords'] != null) {
        return (body['passwords'] as List)
            .map<PasswordModel>((e) => PasswordModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch passwords: ${res.statusCode} ${res.body}');
    }
  }

  // Add a password -> returns created item or success message
  Future<PasswordModel> addPassword(PasswordModel model, {String? token}) async {
    final uri = Uri.parse('$base/passwords');
    final res = await http.post(uri, headers: _headers(token), body: jsonEncode(model.toJson()));

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = jsonDecode(res.body);
      // if backend returns inserted row or id, adapt accordingly
      if (body is Map && body['id'] != null) {
        return PasswordModel.fromJson(body as Map<String, dynamic>);
      } else {
        // try to fetch list and return last added — fallback
        return PasswordModel.fromJson(body as Map<String, dynamic>);
      }
    } else {
      throw Exception('Failed to add password: ${res.statusCode} ${res.body}');
    }
  }

  // Update existing password
  Future<PasswordModel> updatePassword(PasswordModel model, {String? token}) async {
    if (model.id == null) throw Exception('Password id is required for update.');
    final uri = Uri.parse('$base/passwords/${model.id}');
    final res = await http.put(uri, headers: _headers(token), body: jsonEncode(model.toJson()));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return PasswordModel.fromJson(body as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update password: ${res.statusCode} ${res.body}');
    }
  }

  // Delete password by id
  Future<void> deletePassword(int id, {String? token}) async {
    final uri = Uri.parse('$base/passwords/$id');
    final res = await http.delete(uri, headers: _headers(token));

    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete password: ${res.statusCode} ${res.body}');
    }
  }

  // Extra: simple login/signup wrappers (optional)
  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    try {
      final uri = Uri.parse('$base/signup');
      print('Attempting signup to: $uri');
      print('Data: {name: $name, email: $email}');

      final res = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name, 'email': email, 'password': password}))
          .timeout(const Duration(seconds: 10));

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      } else {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final uri = Uri.parse('$base/login');
      print('Attempting login to: $uri');
      print('Data: {email: $email}');

      final res = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}))
          .timeout(const Duration(seconds: 10));

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      return jsonDecode(res.body);
    } catch (e) {
      print('Login error: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Test connectivity to backend
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse('$base/');
      print('Testing connection to: $uri');

      final res = await http.get(uri).timeout(const Duration(seconds: 5));
      print('Connection test response: ${res.statusCode}');

      return res.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(String token, String name) async {
    // Backend doesn't support profile updates yet
    // Return failure so auth controller can handle local update
    return {
      'success': false, 
      'error': 'Backend update not implemented yet'
    };
  }

  // Forgot password - request password reset
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final uri = Uri.parse('$base/forgot-password');
      print('Sending password reset request for email: $email');

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10));

      print('Forgot password response: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        return {'success': true, ...jsonDecode(res.body)};
      } else {
        final error = jsonDecode(res.body);
        return {'success': false, 'error': error['error'] ?? 'Failed to send password reset email'};
      }
    } catch (e) {
      print('Forgot password error: $e');
      return {'success': false, 'error': 'Failed to connect to server: $e'};
    }
  }

  // Delete user account
  Future<Map<String, dynamic>> deleteAccount(String token) async {
    try {
      final uri = Uri.parse('$base/delete-account');
      print('Attempting to delete account');

      final res = await http.delete(
        uri,
        headers: _headers(token),
      ).timeout(const Duration(seconds: 10));

      print('Delete account response: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        return {'success': true, ...jsonDecode(res.body)};
      } else {
        final error = jsonDecode(res.body);
        return {'success': false, 'error': error['error'] ?? 'Failed to delete account'};
      }
    } catch (e) {
      print('Delete account error: $e');
      return {'success': false, 'error': 'Failed to connect to server: $e'};
    }
  }
}
