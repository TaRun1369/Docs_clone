import 'package:docs_clone_flutter/screnns/document_screen.dart';
import 'package:docs_clone_flutter/screnns/home_screen.dart';
import 'package:docs_clone_flutter/screnns/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
   
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id':(route) =>  MaterialPage(child: DocumentScreen(
    id: route.pathParameters['id'] ?? '',// pathparameters ke bracket mein wahi aayega jo colon ke baad hai ...yaha wo 'id' hai
  ),
  ),
   
});