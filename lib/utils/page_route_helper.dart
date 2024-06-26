import 'package:flutter/material.dart';

enum PageTransitionType {
  slideInFromRight,
  slideInFromLeft,
  slideInFromTop,
  slideInFromBottom,
}

class PageRouteHelper {
  static PageRouteBuilder<T> slideInRoute<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 500),
    PageTransitionType transitionType = PageTransitionType.slideInFromRight,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideIn(
          child,
          animation,
          transitionType: transitionType,
          curve: curve,
        );
      },
      transitionDuration: duration,
    );
  }

  static Widget slideIn(
    Widget page,
    Animation<double> animation, {
    PageTransitionType transitionType = PageTransitionType.slideInFromRight,
    Curve curve = Curves.easeInOut,
  }) {
    Offset begin;

    switch (transitionType) {
      case PageTransitionType.slideInFromRight:
        begin = const Offset(1.0, 0.0);
        break;
      case PageTransitionType.slideInFromLeft:
        begin = const Offset(-1.0, 0.0);
        break;
      case PageTransitionType.slideInFromTop:
        begin = const Offset(0.0, -1.0);
        break;
      case PageTransitionType.slideInFromBottom:
        begin = const Offset(0.0, 1.0);
        break;
    }

    const end = Offset.zero;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: tween.animate(
        CurvedAnimation(
          curve: curve,
          parent: animation,
        ),
      ),
      child: page,
    );
  }
}
