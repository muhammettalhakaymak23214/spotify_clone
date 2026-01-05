import 'package:flutter/material.dart';

final class NavigationService {
  NavigationService._();
  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _state => navigatorKey.currentState;

  void push(Widget page, {String? routeName}) {
    _state?.push(
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => page,
      ),
    );
  }

  void pushAndRemoveUntil(Widget page, {String? routeName}) {
    _state?.pushAndRemoveUntil(
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => page,
      ),
      (route) => false,
    );
  }

  void back() {
    if (_state?.canPop() ?? false) {
      _state?.pop();
    }
  }
}