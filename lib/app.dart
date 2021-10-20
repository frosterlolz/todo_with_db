import 'package:flutter/material.dart';
import 'package:todo_with_db/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key}) : super(key: key);

  final String mainTitle = 'Todo with db';
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: mainTitle,
        onGenerateRoute: mainNavigation.onGenerateRoute,
        initialRoute: mainNavigation.initialRoute,
        routes: mainNavigation.routes,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
      );
}
