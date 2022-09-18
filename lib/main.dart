// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(title: "Welcome to Flutter", home: MyScaffold()));
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({super.key});

  @override
  State<MyScaffold> createState() => MyScaffoldState();
}

enum TabItem { track, invest, swap, settings }

const Map<TabItem, String> tabName = {
  TabItem.track: "Track",
  TabItem.invest: "Invest",
  TabItem.swap: "Swap",
  TabItem.settings: "Settings"
};

const Map<TabItem, IconData> tabIcon = {
  TabItem.track: Icons.bar_chart_rounded,
  TabItem.invest: Icons.monetization_on_outlined,
  TabItem.swap: Icons.swap_horiz_rounded,
  TabItem.settings: Icons.settings
};

const Map<TabItem, Widget> tabBody = {
  TabItem.track: TrackScreen(),
  TabItem.invest: InvestScreen(),
  TabItem.swap: Center(child: Text('LAM World')),
  TabItem.settings: SettingsScreen(),
};

class MyScaffoldState extends State<MyScaffold> {
  int _selectedIndex = 0;

  @override
  void initState() {
    Provider.of<AppModel>(context, listen: false).init();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
            SafeArea(child: tabBody[TabItem.values.elementAt(_selectedIndex)]!),
        bottomNavigationBar: BottomNavigationBar(
            items: TabItem.values
                .map((tabItem) => BottomNavigationBarItem(
                    icon: Icon(tabIcon[tabItem]), label: tabName[tabItem]))
                .toList(),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped));
  }
}
