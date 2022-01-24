import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  //PopNavigatorRouterDelegateMixin is required to handle back button presses on Android. It .provides the popRoute method that we will override.

  final _pages = <Page>[];

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {}

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    popRoute();

    return true;
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();

      return Future.value(true);
    }

    return _confirmAppExit();
  }

  Future<bool> _confirmAppExit() {
  return showDialog<bool>(
    context: navigatorKey.currentContext,
    builder: (context) {
      return AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, true),
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      );
    });
}
}
