import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uf_flutter_app/screens/invest/invest.dart';
import 'package:uf_flutter_app/screens/track/track.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  //get controller => null;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  late AnimationController animationController;
  late List<Widget> _pages;

  //static bool displayNav = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _pages = <Widget>[
      const TrackScreen(),
      InvestScreen(
        isHideBottomNavBar: (isHideBottomNavBar) {
          isHideBottomNavBar
              ? animationController.forward()
              : animationController.reverse();
        },
      ),
      const Text("Swap screen coming soon"),
      const Text("Profile screen coming soon"),
    ];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // void listen() {
  //   final direction = controller.position.userScrollDirection;
  //   if (direction == ScrollDirection.forward) {
  //     setState(() {
  //       displayNav = true;
  //     });
  //   } else if (direction == ScrollDirection.reverse) {
  //     setState(() {
  //       displayNav = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: SizeTransition(
        sizeFactor: animationController,
        axisAlignment: -1.0,
        child: SizedBox(
          height: 80,
          child: Wrap(children: [
            BottomNavigationBar(
                backgroundColor: const Color(0xFF161616),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                elevation: 10,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedItemColor: const Color(0xFF25CED1),
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: const Color(0xFFE4E4E4),
                enableFeedback: false,
                items: const [
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.chartColumn,
                      ),
                      activeIcon: FaIcon(
                        FontAwesomeIcons.chartColumn,
                      ),
                      label: "Track"),
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.coins,
                      ),
                      activeIcon: FaIcon(
                        FontAwesomeIcons.coins,
                      ),
                      label: "Invest"),
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.arrowRightArrowLeft,
                      ),
                      activeIcon: FaIcon(
                        FontAwesomeIcons.arrowRightArrowLeft,
                      ),
                      label: "Swap"),
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.wrench,
                      ),
                      activeIcon: FaIcon(
                        FontAwesomeIcons.wrench,
                      ),
                      label: "Settings"),
                ]),
          ]),
        ),
      ),
    );
  }
}
