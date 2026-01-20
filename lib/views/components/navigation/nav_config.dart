import 'package:cltvspj/utils/enum_routes.dart';
import 'package:flutter/material.dart';
import 'nav_destination.dart';

class NavConfig {
  static const mobile = <NavDestination>[
    NavDestination(AppRoute.home, Icons.calculate),
    NavDestination(AppRoute.clt, Icons.work),
    NavDestination(AppRoute.pj, Icons.business),
    NavDestination(AppRoute.settings, Icons.settings),
  ];

  static const desktop = <NavDestination>[
    NavDestination(AppRoute.home, Icons.calculate),
    NavDestination(AppRoute.clt, Icons.work),
    NavDestination(AppRoute.pj, Icons.business),
    NavDestination(AppRoute.user, Icons.person),
    NavDestination(AppRoute.settings, Icons.settings),
  ];
}
