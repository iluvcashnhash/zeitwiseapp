import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/main_chat_screen/main_chat_screen.dart';
import '../presentation/detox_feed_screen/detox_feed_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String mainChatScreen = '/main-chat-screen';
  static const String detoxFeedScreen = '/detox-feed-screen';
  static const String profileScreen = '/profile-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    mainChatScreen: (context) => const MainChatScreen(),
    detoxFeedScreen: (context) => const DetoxFeedScreen(),
    profileScreen: (context) => const ProfileScreen(),
    // TODO: Add your other routes here
  };
}
