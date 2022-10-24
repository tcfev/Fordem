import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuerdem/src/screens/authorization.dart';
import 'package:fuerdem/src/screens/barcode_scanner.dart';
import 'package:fuerdem/src/screens/compose.dart';

import '../../../main.dart';

// source:
// https://www.filledstacks.com/snippet/clean-navigation-in-flutter-using-generated-routes/
class PageRouter {
  /// Route names
  static const String homeRoute = '/';
  static const String barcodeRoute = '/barcode';
  static const String authorizationRoute = '/authorization';
  static const String composeRoute = '/compose';
  static const String composeEditorRoute = '/compose/editor';

  /// Generate routes base on route name.
  ///
  /// example:
  /// case homeRoute:
  ///        return _getPageRoute(Home(), settings);
  ///
  /// To pass arguments to a route, use [settings.arguments] or
  /// get queryParameters map from [routingData] or get a specific value with operator [].\
  ///
  /// example with settings.arguments:
  /// case secondRoute:
  ///        final dataPass = settings.arguments as DataPass;
  ///        return _getPageRoute(SecondPage(dataPass), settings);
  /// In above example dataPass type is [DataPass] which can be any other types.
  ///
  /// example with query parameters:
  /// case secondRoute:
  ///        final name = routingData.queryParameters['name'];
  ///        return _getPageRoute(SecondPage(name), settings);
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routingData = settings.name.getRoutingData;
    switch (routingData.route) {
      case homeRoute:
        return _getPageRoute(MyHomePage(), settings);
      case barcodeRoute:
        return _getPageRoute(BarcodeScanner(), settings);
      case authorizationRoute:
        final dataPass = settings.arguments as DataPass;
        return _getPageRoute(Authorization(dataPass), settings);
      case composeRoute:
        return _getPageRoute(Compose(), settings);
      case composeEditorRoute:
        return _getPageRoute(ComposeEditor(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  /// Push the given route onto the navigator that most tightly encloses the given context. .
  ///
  /// usage:
  /// PageRouter.namedNavigateTo(context, PageRouter.routName,
  ///               replacement: shouldReplace ,
  ///               arguments: argumentsToPassToRoute,
  ///               queryParams: queryParametersToPassWithUrl);
  static Future<Object> namedNavigateTo(
    BuildContext context,
    String routeName, {
    bool replacement = false,
    Object arguments,
    Map<String, String> queryParams,
  }) {
    final name = kIsWeb && queryParams != null
        ? Uri(path: routeName, queryParameters: queryParams).toString()
        : routeName;
    if (replacement) {
      return Navigator.pushReplacementNamed(context, name,
          arguments: arguments);
    } else {
      return Navigator.pushNamed(context, name, arguments: arguments);
    }
  }

  /// Pop the top-most route off the navigator that most tightly encloses the given context.
  static void pop(BuildContext context, {Object result}) {
    if (result == null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, result);
    }
  }
}

class DataPass {
  DataPass(this.items);

  final Map<String, dynamic> items;

  String operator [](String key) => items[key];
}

/// Build route with transparent background.
class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) =>
    _FadeRoute(child: child, routeName: settings.name);

/// Build route with fade transition.
class _FadeRoute extends PageRouteBuilder {
  _FadeRoute({
    this.child,
    this.routeName,
  }) : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

  final Widget child;
  final String routeName;
}

class RoutingData {
  RoutingData({
    this.route,
    this.queryParameters,
  });

  final String route;
  final Map<String, String> queryParameters;

  String operator [](String key) => queryParameters[key];
}

extension RouterExtention on String {
  RoutingData get getRoutingData {
    final uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}
