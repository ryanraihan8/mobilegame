import 'dart:core';

import 'package:flutter/material.dart';
import 'package:new_super_jumper/main.dart';
import 'package:new_super_jumper/ui/leaderboards_screen.dart';
import 'package:new_super_jumper/ui/main_menu_screen.dart';

enum Routes {
  main('/'),
  game('/game'),
  leaderboard('/leaderboard'),
  login('/login'),
  signup('/signup');

  final String route;

  const Routes(this.route);

  static Route routes(RouteSettings settings) {
    MaterialPageRoute _buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    final routeName = Routes.values.firstWhere((e) => e.route == settings.name);

    switch (routeName) {
      case Routes.main:
        return _buildRoute(const MainMenuScreen());
      case Routes.game:
        return _buildRoute(const MyGameWidget());
      case Routes.leaderboard:
        return _buildRoute(const LeaderboardScreen());
      case Routes.login:
        return _buildRoute(const LoginScreen());
      case Routes.signup:
        return _buildRoute(const SignupScreen());
      default:
        throw Exception('Route does not exists');
    }
  }
}

extension BuildContextExtension on BuildContext {
  void pushAndRemoveUntil(Routes route) {
    Navigator.pushNamedAndRemoveUntil(this, route.route, (route) => false);
  }

  void push(Routes route) {
    Navigator.pushNamed(this, route.route);
  }
}
