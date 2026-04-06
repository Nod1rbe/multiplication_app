import 'package:flutter/material.dart';
import 'package:multiplication_app/domain/entities/table_info.dart';
import 'package:multiplication_app/presentation/learn/learn_page.dart';
import 'package:multiplication_app/presentation/main_view.dart';
import 'package:multiplication_app/presentation/result/result_page.dart';

import '../../presentation/home/home_page.dart' show HomePage;

abstract class AppRouter {
  static const String home = '/';
  static const String learn = '/learn';
  static const String result = '/result';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainView());
      case learn:
        final info = settings.arguments as TableInfo;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, __) => LearnPage(tableInfo: info),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
            child: child,
          ),
        );
      case result:
        final args = settings.arguments as ResultPageArgs;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, __) => ResultPage(args: args),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
