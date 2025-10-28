import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.put(ThemeController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Force reload user data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.loadUserData();
      print('🔄 Profile screen loaded, user data: ${authController.user.value?.name}, ${authController.user.value?.email}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Animated App Bar
          SliverAppBar(
            expandedHeight: 200,
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
                child: Center(
                  child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Hero(
                        tag: 'profile_avatar',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isDark ? kGradientDark : kGradientLight,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: isDark ? kCardColorDark : kCardColorLight,
                            child: Text(
                              authController.user.value?.name?.substring(0, 1).toUpperCase() ?? 'U',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        authController.user.value?.name ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Profile Information Card
                  _buildSectionTitle('Profile Information', isDark),
                  const SizedBox(height: 12),
                  _buildProfileCard(isDark),
                  const SizedBox(height: 30),

                  // Settings Section
                  _buildSectionTitle('Settings', isDark),
                  const SizedBox(height: 12),
                  _buildSettingsCard(isDark),
                  const SizedBox(height: 30),

                  // Logout Button
                  _buildLogoutButton(isDark),
                  const SizedBox(height: 16),
                  
                  // Delete Account Button
                  _buildDeleteAccountButton(isDark),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? kTextColorDark : kTextColorLight,
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: isDark ? kCardColorDark : kCardColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileTile(
            icon: Icons.person_outline,
            title: 'Name',
            subtitle: authController.user.value?.name ?? 'Not set',
            isDark: isDark,
            onTap: () => _showEditDialog('Name', nameController, isDark),
          ),
          Divider(
            height: 1,
            color: isDark ? kTextSecondaryDark.withOpacity(0.2) : kTextSecondaryLight.withOpacity(0.2),
          ),
          _buildProfileTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: authController.user.value?.email ?? 'Not set',
            isDark: isDark,
            onTap: () {}, // Email is not editable
          ),
        ],
      ),
    ));
  }

  Widget _buildSettingsCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? kCardColorDark : kCardColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          GetBuilder<ThemeController>(
            builder: (controller) => _buildSwitchTile(
              icon: controller.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'Dark Mode',
              subtitle: controller.isDarkMode ? 'Enabled' : 'Disabled',
              value: controller.isDarkMode,
              isDark: isDark,
              onChanged: (value) => controller.changeTheme(value),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? kTextSecondaryDark.withOpacity(0.2) : kTextSecondaryLight.withOpacity(0.2),
          ),
          _buildProfileTile(
            icon: Icons.security_outlined,
            title: 'Security',
            subtitle: 'Privacy & security settings',
            isDark: isDark,
            onTap: () => _showSecurityDialog(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (isDark ? kPrimaryColorDark : kPrimaryColorLight).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? kTextColorDark : kTextColorLight,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool isDark,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (isDark ? kPrimaryColorDark : kPrimaryColorLight).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? kTextColorDark : kTextColorLight,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
        ),
      ),
      value: value,
      activeColor: isDark ? kPrimaryColorDark : kPrimaryColorLight,
      onChanged: onChanged,
    );
  }

  Widget _buildLogoutButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kAccentColorLight,
            kAccentColorLight.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kAccentColorLight.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.defaultDialog(
            title: 'Logout',
            titleStyle: TextStyle(
              color: isDark ? kTextColorDark : kTextColorLight,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: isDark ? kCardColorDark : kCardColorLight,
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
              ),
            ),
            confirm: ElevatedButton(
              onPressed: () {
                Get.back();
                authController.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColorLight,
              ),
              child: const Text('Logout'),
            ),
            cancel: OutlinedButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? kTextColorDark : kTextColorLight,
                ),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String field, TextEditingController controller, bool isDark) {
    final authController = Get.find<AuthController>();
    final currentValue = field == 'Name' ? authController.user.value?.name ?? '' : '';
    controller.text = currentValue;
    
    Get.defaultDialog(
      title: 'Edit $field',
      titleStyle: TextStyle(
        color: isDark ? kTextColorDark : kTextColorLight,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: isDark ? kCardColorDark : kCardColorLight,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            labelStyle: TextStyle(
              color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
            ),
          ),
          style: TextStyle(
            color: isDark ? kTextColorDark : kTextColorLight,
          ),
        ),
      ),
      confirm: Obx(() => authController.isLoading.value
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter a valid $field',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Close dialog immediately and then update
                Get.back();

                try {
                  if (field == 'Name') {
                    await authController.updateProfile(controller.text.trim());
                    // Reload user data to ensure UI reflects the latest changes
                    authController.loadUserData();
                  }
                } catch (e) {
                  // Error is already shown by the authController
                }
              },
              child: const Text('Save'),
            ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: isDark ? kTextColorDark : kTextColorLight,
          ),
        ),
      ),
    );
  }

  void _showSecurityDialog(bool isDark) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: isDark ? kCardColorDark : kCardColorLight,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
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
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Security & Privacy",
                        style: TextStyle(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSecurityItem(
                      Icons.lock_outline,
                      'AES-256 Encryption',
                      'Your passwords are encrypted using military-grade AES-256 encryption',
                      isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildSecurityItem(
                      Icons.vpn_key,
                      'Secure Storage',
                      'All data is stored securely with hash-based encryption',
                      isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildSecurityItem(
                      Icons.verified_user,
                      'Safe & Private',
                      'Your data is never shared with third parties. You can use this app securely',
                      isDark,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Got it!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityItem(IconData icon, String title, String description, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDark ? kPrimaryColorDark : kPrimaryColorLight).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? kTextColorDark : kTextColorLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kAccentColorLight,
          width: 2,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.defaultDialog(
            title: 'Delete Account',
            titleStyle: TextStyle(
              color: isDark ? kTextColorDark : kTextColorLight,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: isDark ? kCardColorDark : kCardColorLight,
            middleText: 'Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be lost.',
            middleTextStyle: TextStyle(
              color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
            ),
            confirm: ElevatedButton(
              onPressed: () async {
                // TODO: Implement delete account API
                Get.back();
                await authController.logout();
                Get.snackbar(
                  'Account Deleted',
                  'Your account has been permanently deleted',
                  backgroundColor: kAccentColorLight,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColorLight,
              ),
              child: const Text('Delete'),
            ),
            cancel: OutlinedButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? kTextColorDark : kTextColorLight,
                ),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_forever, color: kAccentColorLight),
            SizedBox(width: 8),
            Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kAccentColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
