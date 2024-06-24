// loogedOut
// loggedIn

import 'package:flutter/material.dart';
import 'package:reddit_tutorial/feature/Home/home_Screen.dart';
import 'package:reddit_tutorial/feature/auth/screens/login_screen.dart';
import 'package:reddit_tutorial/feature/community/screens/community_screen.dart';
import 'package:reddit_tutorial/feature/community/screens/create_community.dart';
import 'package:reddit_tutorial/feature/community/screens/edit_community_screen.dart';
import 'package:reddit_tutorial/feature/community/screens/mod_tools_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

final loggedInRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(
        child: HomeScreen(),
      ),
  "/create_community": (_) => const MaterialPage(
        child: CreateCommunityScreen(),
      ),
  "/r/:name": (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters["name"]!,
        ),
      ),
  "/mod-tools/:name": (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters["name"]!,
        ),
      ),
  "/edit-community/:name": (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters["name"]!,
        ),
      ),
});
