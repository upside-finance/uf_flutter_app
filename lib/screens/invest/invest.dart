// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:uf_flutter_app/utils/app_layout.dart';

import '../../app_model.dart';
import '../../helper.dart';
import '../../widgets/connect_wallet.dart';

class InvestScreen extends StatefulWidget {
  final Function(bool) isHideBottomNavBar;

  const InvestScreen({
    Key? key,
    required this.isHideBottomNavBar,
  }) : super(key: key);

  @override
  State<InvestScreen> createState() => InvestScreenState();
}

class InvestScreenState extends State<InvestScreen>
    with AutomaticKeepAliveClientMixin<InvestScreen> {
  bool isHidden = true;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            widget.isHideBottomNavBar(true);
            setState(() {
              isHidden = false;
            });

            break;
          case ScrollDirection.reverse:
            widget.isHideBottomNavBar(false);
            setState(() {
              isHidden = true;
            });

            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      model.fbAnalytics?.setCurrentScreen(screenName: "Invest");

      return Scaffold(
        appBar: AppBar(title: const ConnectWallet()),
        body: Column(
          children: [
            AnimatedContainer(
              clipBehavior: Clip.hardEdge,
              height: isHidden ? 0 : 60,
              decoration: const BoxDecoration(color: Color(0xFF2E2E2E)),
              duration: const Duration(milliseconds: 300),
              child: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                    ),
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
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: ListView(
                    //controller: ScrollController(initialScrollOffset: 2),
                    //controller: ScrollController(),
                    children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ...(model.pools.values.toList()
                        ..sort((a, b) => (a.TVL ?? 0) < (b.TVL ?? 0)
                            ? 1
                            : (a.TVL ?? 0) > (b.TVL ?? 0)
                                ? -1
                                : 0))
                      .map((pool) => Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.symmetric(
                              vertical: AppLayout.getHeight(4),
                              horizontal: AppLayout.getWidth(7)),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF505050),
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                              cornerRadius: 15,
                            )),
                          ),
                          child: InkWell(
                            onTap: () {
                              model.fbAnalytics?.logEvent(
                                  name: "One-click invest",
                                  parameters: {
                                    "Pool Address": pool.address,
                                    "Pool":
                                        "${pool.asset_1_unit_name} / ${pool.asset_2_unit_name}",
                                    "Protocol": protocolMap[pool.protocol]?.name
                                  });
                              launchUrl(Uri.parse(pool.genAddLiquidityLink()));
                            },
                            child: Stack(children: [
                              //Pool App Icon
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppLayout.getHeight(5),
                                    horizontal: AppLayout.getWidth(7)),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF716F70),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15)),
                                ),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          width: 15,
                                          child: Image.asset(
                                              protocolMap[pool.protocol]
                                                      ?.logoURI ??
                                                  '')),
                                      const SizedBox(width: 3),
                                      Text(protocolMap[pool.protocol]?.name ??
                                          '')
                                    ]),
                              ),
                              //End PAI

                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 35, bottom: 15),
                                  child: Row(children: [
                                    SizedBox(
                                        width: 30,
                                        child: getASAiconWidget(
                                            model.asaIconList,
                                            pool.asset_1_id)),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 30,
                                        child: getASAiconWidget(
                                            model.asaIconList,
                                            pool.asset_2_id)),

                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            "  ${pool.asset_1_unit_name} / ${pool.asset_2_unit_name}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))),

                                    //TVL and APY
                                    Row(children: [
                                      Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            "TVL",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          SizedBox(
                                              height: AppLayout.getHeight(7)),
                                          Text(
                                              pool.TVL != null
                                                  ? '\$${formatNumber(pool.TVL)}'
                                                  : '-',
                                              style: const TextStyle(
                                                  color: Color(0xFF25CED1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      SizedBox(width: AppLayout.getWidth(15)),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text("APY[7D]",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300)),
                                          SizedBox(
                                              height: AppLayout.getHeight(7)),
                                          Text(
                                              pool.APY != null
                                                  ? "${(pool.APY! * 100).toStringAsFixed(2)}%"
                                                  : "-",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      )
                                    ])
                                  ])),
                            ]),
                          )))
                ].toList()),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
