import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uf_flutter_app/screens/explore.dart';
import 'package:uf_flutter_app/screens/invest/invest.dart';
import 'package:uf_flutter_app/screens/swap.dart';
import 'package:uf_flutter_app/screens/track/track.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    const TrackScreen(),
    const InvestScreen(),
    const SwapPage(),
    const ExploreScreen(),
    const Text("Profile screen coming soon"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Center(child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: Container(
        // height: AppLayout.getHeight(85),
        padding: EdgeInsets.only(top: AppLayout.getHeight(5)),
        decoration: const BoxDecoration(
          color: Color(0xFF161616),
        ),
        child: BottomNavigationBar(
            backgroundColor: const Color(0xFF161616),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontSize: 9, height: 2.5),
            selectedIconTheme: const IconThemeData(size: 30),
            unselectedFontSize: 9,
            selectedItemColor: const Color(0xFF25CED1),
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: const Color(0xFFE4E4E4),
            enableFeedback: false,
            items: const [
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.chartColumn,
                  ),
                  label: "Track"),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.coins,
                  ),
                  label: "Invest"),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.arrowRightArrowLeft,
                  ),
                  label: "Swap"),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.compass,
                  ),
                  label: "Explore"),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.wrench,
                  ),
                  label: "Settings"),
            ]),
      ),
    );
  }
}
