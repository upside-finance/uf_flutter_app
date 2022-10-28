import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_layout.dart';
import '../widgets/connect_wallet.dart';

const List<String> list = <String>[
  'Market cap',
  'Price',
  'Name',
  'Change %',
  'Top Gainers',
  'Top Losers'
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const ConnectWallet()),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: AppLayout.getHeight(4),
                horizontal: AppLayout.getWidth(7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton(
                    value: dropdownValue,
                    icon: const FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 12,
                    ),
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFFD9D9D9)),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ],
            ),
          ),
          Expanded(
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2E2E2E),
                        Colors.transparent,
                        Colors.transparent,
                        Color(0xFF2E2E2E),
                      ],
                      stops: [0.0, 0.02, 0.9, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: AppLayout.getHeight(4),
                          horizontal: AppLayout.getWidth(7)),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF505050),
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                          cornerRadius: 15,
                          cornerSmoothing: 1,
                        )),
                      ),
                      child: Text("Text"))))
        ],
      ),
    );
  }
}
