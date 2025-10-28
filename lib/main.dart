import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    Get.put(AuthController());
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vaultify',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.theme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
