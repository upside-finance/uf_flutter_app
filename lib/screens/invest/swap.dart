import 'package:dio/dio.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:uf_flutter_app/utils/token_list.dart';
import 'package:uf_flutter_app/widgets/swap_widget.dart';

import '../../utils/app_layout.dart';
import '../../widgets/connect_wallet.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const ConnectWallet()),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Net worth",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  Row(
                    children: const [
                      Text(
                        "USD ",
                        style: TextStyle(
                            color: Color(0xFF25CED1),
                            fontSize: 30,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        "****",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(5),
                  horizontal: AppLayout.getWidth(7)),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: AppLayout.getHeight(300),
                decoration: ShapeDecoration(
                  color: const Color(0xFF505050),
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 22, cornerSmoothing: 1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.getHeight(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Swap", style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppLayout.getHeight(8)),
                          child: Column(
                            children: [
                              SwapWidget(swap: "from"),
                              SwapWidget(swap: "to"),
                            ],
                          ),
                        ),
                        Positioned(
                            top: AppLayout.getSize(context).height * 0.0875,
                            left: AppLayout.getSize(context).width * 0.45,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppLayout.getWidth(7),
                                  vertical: AppLayout.getHeight(5)),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFF505050),
                                    width: AppLayout.getHeight(3)),
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFF457B9D),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.arrowDown,
                                size: 18,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
