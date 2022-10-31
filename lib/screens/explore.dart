import 'package:dots_indicator/dots_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

import '../utils/app_layout.dart';
import '../widgets/connect_wallet.dart';

const List<Map<String, dynamic>> tokenList = [
  {
    "token": "Algo",
    "icon": "AL",
    "market_cap": "\$5.5B",
    "price_usd": "\$0.3681",
    "day_change": "-0.1"
  },
  {
    "token": "USDC",
    "icon": "UC",
    "market_cap": "\$40B",
    "price_usd": "\$1.0001",
    "day_change": "0.005"
  },
  {
    "token": "Wrapped BTC",
    "icon": "WB",
    "market_cap": "\$2.56B",
    "price_usd": "\$20644.21",
    "day_change": "-3.07"
  },
  {
    "token": "goMint",
    "icon": "GM",
    "market_cap": "\$103.97M",
    "price_usd": "\$0.0229",
    "day_change": "3.13"
  },
  {
    "token": "Bank",
    "icon": "BK",
    "market_cap": "\$12.45M",
    "price_usd": "\$0.0142",
    "day_change": "-7.56"
  },
  {
    "token": "Yieldly",
    "icon": "YL",
    "market_cap": "\$2.14M",
    "price_usd": "\$0.0003",
    "day_change": "1.205"
  },
];

const List<String> intervalList = ["1H", "1D", "1W", "1M", "1Y"];

const List<String> list = [
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
  Map<String, dynamic> selectedToken = {};

  double infoModuleHeight = 0.0;
  String selectedInterval = "1H";

  final _pageController = PageController();
  double currentPage = 0;

  //indicator handler
  @override
  void initState() {
    //page controller is always listening
    //every pageview is scrolled sideways it will take the index page
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.toDouble();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const ConnectWallet()),
      body: Column(
        children: [
          //search box at the top
          Container(
            height: 35,
            margin: EdgeInsets.symmetric(
                vertical: AppLayout.getHeight(4),
                horizontal: AppLayout.getWidth(7)),
            child: Form(
                child: TextField(
              style: const TextStyle(
                color: Color(0xFF161616),
              ),
              decoration: InputDecoration(
                  hintText: "Token name or Asset ID",
                  hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: AppLayout.getWidth(10)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9)),
            )),
          ),

          //Sort by or filter list
          Container(
            margin: EdgeInsets.only(
                top: AppLayout.getHeight(4),
                bottom: AppLayout.getHeight(20),
                left: AppLayout.getWidth(7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  height: 30,
                  // padding: EdgeInsets.only(
                  //     top: AppLayout.getHeight(3),
                  //     bottom: AppLayout.getHeight(3),
                  //     left: AppLayout.getHeight(8)),

                  child: DropdownSearch<String>(
                    dropdownButtonProps: const DropdownButtonProps(
                        icon: FaIcon(FontAwesomeIcons.chevronDown),
                        iconSize: 15),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      textAlignVertical: TextAlignVertical(y: 0.0),
                      dropdownSearchDecoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(left: 12),
                        hintText: "Token",
                        filled: true,
                        fillColor: Color(0xFF494952),
                        //focusColor: Colors.blue,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFD9D9D9),
                                width: 1,
                                strokeAlign: StrokeAlign.outside),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFD9D9D9),
                                width: 1,
                                strokeAlign: StrokeAlign.outside),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    selectedItem: dropdownValue,
                    items: list,
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      menuProps: const MenuProps(
                        barrierColor: Colors.black26,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      containerBuilder: (ctx, popupWidget) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                'assets/images/arrow-up.png',
                                fit: BoxFit.fill,
                                color: const Color(0xFF505050),
                                height: 12,
                                width: 25,
                              ),
                            ),
                            Flexible(
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFF505050),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF2E2E2E),
                                        blurRadius: 50,
                                        spreadRadius: 2,
                                      )
                                    ]),
                                child: popupWidget,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          //token info container that is hidden (height=0) by default
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 100),
            height: infoModuleHeight,
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
            child: infoModuleHeight > 150
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppLayout.getHeight(10)),
                            child: InkWell(
                              onTap: () {
                                setState(() => infoModuleHeight = 0);
                              },

                              //close button for info box
                              child: const FaIcon(
                                FontAwesomeIcons.x,
                                size: 15,
                                color: Color(0xFFA0A0A0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        selectedToken["token"].toString(),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: AppLayout.getHeight(5),
                      ),
                      //graph or info based off selected token and interval period selected. defaults to 1H
                      Expanded(
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      selectedToken["price_usd"].toString(),
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      width: AppLayout.getWidth(5),
                                    ),
                                    (double.parse(
                                                selectedToken["day_change"]) >=
                                            0
                                        ? Text(
                                            "+${double.parse(selectedToken["day_change"])}%",
                                            style: const TextStyle(
                                                color: Color(0xFF32FF90),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            "${double.parse(selectedToken["day_change"]).toString()}%",
                                            style: const TextStyle(
                                                color: Color(0xFFFF3263),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ))
                                  ],
                                ),
                                Container(
                                  height: 180,
                                  margin: EdgeInsets.symmetric(
                                      vertical: AppLayout.getHeight(10)),
                                  decoration: BoxDecoration(
                                      color: Colors.purple.shade900),
                                  child: Center(
                                    child: Text(selectedInterval),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppLayout.getWidth(16.0),
                                      vertical: AppLayout.getHeight(10.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Market Cap",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          selectedToken["market_cap"]
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppLayout.getWidth(16.0),
                                      vertical: AppLayout.getHeight(10.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Open / Close",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          selectedToken["market_cap"]
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppLayout.getWidth(16.0),
                                      vertical: AppLayout.getHeight(10.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("High / Low",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          selectedToken["market_cap"]
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppLayout.getWidth(16.0),
                                      vertical: AppLayout.getHeight(10.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Change",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      (double.parse(selectedToken[
                                                  "day_change"]) >=
                                              0
                                          ? Text(
                                              "+${double.parse(selectedToken["day_change"])}%",
                                              style: const TextStyle(
                                                  color: Color(0xFF32FF90),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          : Text(
                                              "${double.parse(selectedToken["day_change"]).toString()}%",
                                              style: const TextStyle(
                                                  color: Color(0xFFFF3263),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ))
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppLayout.getWidth(16.0),
                                      vertical: AppLayout.getHeight(10.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Volume",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          selectedToken["market_cap"]
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      //interval period select
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            for (var interval in intervalList)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedInterval = interval.toString();
                                  });
                                },
                                child: Container(
                                  height: AppLayout.getHeight(25),
                                  width: AppLayout.getWidth(30),
                                  decoration: ShapeDecoration(
                                    color: selectedInterval == interval
                                        ? const Color(0x4025CED1)
                                        : Colors.transparent,
                                    shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                      cornerRadius: 5,
                                      cornerSmoothing: 1,
                                    )),
                                  ),
                                  child: Center(
                                    child: Text(
                                      interval,
                                      style: selectedInterval == interval
                                          ? const TextStyle(
                                              color: Color(0xFF25CED1),
                                              fontWeight: FontWeight.w700)
                                          : const TextStyle(
                                              color: Color(0xFF25CED1)),
                                    ),
                                  ),
                                ),
                              )
                          ]),

                      //page indicator
                      Padding(
                        padding: EdgeInsets.all(AppLayout.getHeight(7.0)),
                        child: DotsIndicator(
                          dotsCount: 2,
                          position: currentPage,
                          decorator: DotsDecorator(
                            size: const Size.square(7.0),
                            color: const Color(0xFF727272),
                            activeColor: const Color(0xFFD9D9D9),
                            activeSize: const Size(14.0, 7.0),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return (infoModuleHeight == 0
                    ? (const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF2E2E2E),
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xFF2E2E2E),
                        ],
                        stops: [0.01, 0.04, 0.9, 1.0],
                      ).createShader(bounds))
                    : (const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF2E2E2E),
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xFF2E2E2E),
                        ],
                        stops: [0.02, 0.1, 0.8, 1.0],
                      ).createShader(bounds)));
              },
              blendMode: BlendMode.dstOut,
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(
                    vertical: AppLayout.getHeight(4),
                    horizontal: AppLayout.getWidth(7)),
                decoration: BoxDecoration(
                  color: const Color(0xFF505050),
                  borderRadius: BorderRadius.vertical(
                      top: infoModuleHeight == 0
                          ? Radius.circular(AppLayout.getHeight(20))
                          : const Radius.circular(0)),
                ),
                child: ListView(
                  children: tokenList
                      .map<Widget>((token) => InkWell(
                            onTap: () {
                              infoModuleHeight = 350;
                              setState(() {
                                // selectedTokenColor = const Color(0x40D9D9D9);
                                selectedToken = token;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    (selectedToken["token"] == token["token"] &&
                                            infoModuleHeight != 0)
                                        ? const Color(0x40D9D9D9)
                                        : const Color(0x40505050),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppLayout.getWidth(7)),
                              child: Column(
                                children: [
                                  SizedBox(height: AppLayout.getHeight(5)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            margin: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            50))),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1)),
                                            child: Center(
                                                child: Text(
                                                    token["icon"].toString())),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                token["token"].toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                token["market_cap"].toString(),
                                                style: const TextStyle(
                                                    color: Color(0xFFA0A0A0),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            token["price_usd"].toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          (double.parse(token["day_change"]) >=
                                                  0
                                              ? Text(
                                                  "+${double.parse(token["day_change"])}%",
                                                  style: const TextStyle(
                                                      color: Color(0xFF32FF90),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              : Text(
                                                  "${double.parse(token["day_change"]).toString()}%",
                                                  style: const TextStyle(
                                                      color: Color(0xFFFF3263),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppLayout.getHeight(5)),
                                  const Divider(
                                    height: 2,
                                    thickness: 1,
                                    indent: 5,
                                    endIndent: 5,
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
