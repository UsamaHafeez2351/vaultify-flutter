import 'package:get/get.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/auth/splash_screen.dart';
import '../views/home/home_screen.dart';
import '../views/profile/profile_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const profile = '/profile';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
    ),
  ];
}
