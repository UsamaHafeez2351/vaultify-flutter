// lib/views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/password_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/constants.dart';
import '../../../routes/app_routes.dart';
import '../widgets/password_card.dart';

class HomeScreen extends StatefulWidget { 
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PasswordController passwordController = Get.put(PasswordController());
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  
  bool _obscurePassword = true;
  String _searchQuery = '';

  void showPasswordDialog(BuildContext context, {bool isEdit = false, int? id, String? currentTitle, String? currentUsername, String? currentPassword}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Reset password visibility when the dialog opens on the screen
    _obscurePassword = true;
    
    if (isEdit && currentTitle != null && currentUsername != null && currentPassword != null) {
      titleController.text = currentTitle;
      usernameController.text = currentUsername;
      passwordFieldController.text = currentPassword;
    } else {
      titleController.clear();
      usernameController.clear();
      passwordFieldController.clear();
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: isDark ? kCardColorDark : kCardColorLight,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
              // Header with gradient gradient
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark ? kGradientDark : kGradientLight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEdit ? Icons.edit : Icons.add_circle_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        isEdit ? "Update Password" : "Add New Password",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildDialogTextField(
                      controller: titleController,
                      label: "Title",
                      hint: "e.g., Gmail, Facebook",
                      icon: Icons.title,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildDialogTextField(
                      controller: usernameController,
                      label: "Username / Email",
                      hint: "Enter username or email",
                      icon: Icons.person_outline,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: passwordFieldController,
                      label: "Password",
                      hint: "Enter password",
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      setDialogState: setDialogState,
                    ),
                    const SizedBox(height: 24),
                    // Buttons here 
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: isDark ? kTextColorDark : kTextColorLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark ? kGradientDark : kGradientLight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: (isDark ? kPrimaryColorDark : kPrimaryColorLight)
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (isEdit && id != null) {
                                  passwordController.updatePassword(
                                    id,
                                    titleController.text.trim(),
                                    usernameController.text.trim(),
                                    passwordFieldController.text.trim(),
                                  );
                                } else {
                                  passwordController.addPassword(
                                    titleController.text.trim(),
                                    usernameController.text.trim(),
                                    passwordFieldController.text.trim(),
                                  );
                                }
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isEdit ? "Update" : "Save",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? kBackgroundColorDark.withOpacity(0.5)
            : kBackgroundColorLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? kTextSecondaryDark.withOpacity(0.2)
              : kTextSecondaryLight.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          color: isDark ? kTextColorDark : kTextColorLight,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
          ),
          labelStyle: TextStyle(
            color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
          ),
          hintStyle: TextStyle(
            color: isDark
                ? kTextSecondaryDark.withOpacity(0.5)
                : kTextSecondaryLight.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required StateSetter setDialogState,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? kBackgroundColorDark.withOpacity(0.5)
            : kBackgroundColorLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? kTextSecondaryDark.withOpacity(0.2)
              : kTextSecondaryLight.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: _obscurePassword,
        style: TextStyle(
          color: isDark ? kTextColorDark : kTextColorLight,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
            ),
            onPressed: () {
              setDialogState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          labelStyle: TextStyle(
            color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
          ),
          hintStyle: TextStyle(
            color: isDark
                ? kTextSecondaryDark.withOpacity(0.5)
                : kTextSecondaryLight.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? kBackgroundColorDark : kBackgroundColorLight,
      body: CustomScrollView(
        slivers: [
          // Beautiful Gradient AppBar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark ? kGradientDark : kGradientLight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Vaultify",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              onPressed: () => Get.toNamed(AppRoutes.profile),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() => Text(
                          "Welcome, ${authController.user.value?.name ?? 'User'}!",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          "${passwordController.passwords.length} passwords stored securely",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Body Content here
          SliverToBoxAdapter(
            child: Obx(() {
              if (passwordController.isLoading.value) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                    ),
                  ),
                );
              }

              if (passwordController.passwords.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: (isDark ? kPrimaryColorDark : kPrimaryColorLight).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_open_rounded,
                            size: 80,
                            color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "No passwords yet",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? kTextColorDark : kTextColorLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap the + button to add your first password",
                          style: TextStyle(
                            color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Filter passwords based on search query
              final filteredPasswords = passwordController.passwords.where((pwd) {
                if (_searchQuery.isEmpty) return true;
                return pwd.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       pwd.username.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? kCardColorDark : kCardColorLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: TextStyle(
                          color: isDark ? kTextColorDark : kTextColorLight,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search passwords...",
                          hintStyle: TextStyle(
                            color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Results count here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _searchQuery.isEmpty
                              ? "Your Passwords"
                              : "Found ${filteredPasswords.length} result${filteredPasswords.length != 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? kTextColorDark : kTextColorLight,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          Text(
                            "of ${passwordController.passwords.length}",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Show message if no results
                    if (filteredPasswords.isEmpty && _searchQuery.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No passwords found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? kTextColorDark : kTextColorLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Try a different search term",
                                style: TextStyle(
                                  color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Password list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredPasswords.length,
                      itemBuilder: (context, index) {
                        final pwd = filteredPasswords[index];
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1,
                          child: PasswordCard(
                            title: pwd.title,
                            username: pwd.username,
                            password: pwd.password,
                            onEdit: () => showPasswordDialog(
                              context,
                              isEdit: true,
                              id: pwd.id,
                              currentTitle: pwd.title,
                              currentUsername: pwd.username,
                              currentPassword: pwd.password,
                            ),
                            onDelete: () => passwordController.deletePassword(pwd.id!),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isDark ? kGradientDark : kGradientLight,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? kPrimaryColorDark : kPrimaryColorLight).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => showPasswordDialog(context),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}
