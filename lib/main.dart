// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uf_flutter_app/screens/bottom_bar.dart';
import './app_model.dart';
import 'screens/settings/settings.dart';
import 'screens/invest/invest.dart';
import 'screens/track/track.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        title: "UpsideFinance",
        home: MyScaffold(),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.dark,
          splashFactory: NoSplash.splashFactory,
          appBarTheme: const AppBarTheme(
              color: Color(0xFF2E2E2E), shadowColor: Colors.transparent),
          scaffoldBackgroundColor: const Color(0xFF2E2E2E),
          primarySwatch: Colors.grey,
        ),
      ),
    );
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({super.key});

  @override
  State<MyScaffold> createState() => MyScaffoldState();
}

class MyScaffoldState extends State<MyScaffold> {
  @override
  void initState() {
    Provider.of<AppModel>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar();
  }
}
