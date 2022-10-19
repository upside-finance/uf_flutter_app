import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';
import '../../app_model.dart';
import '../../helper.dart';
import '../../widgets/connect_wallet.dart';
import 'package:url_launcher/url_launcher.dart';

class InvestScreen extends StatefulWidget {
  const InvestScreen({super.key});

  @override
  State<InvestScreen> createState() => InvestScreenState();
}

class InvestScreenState extends State<InvestScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      model.fbAnalytics?.setCurrentScreen(screenName: "Invest");

      return Scaffold(
        appBar: AppBar(title: const ConnectWallet()),
        body: ShaderMask(
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
              stops: [0.0, 0.02, 0.95, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: ListView(
              controller: ScrollController(initialScrollOffset: 2),
              children: [
                ...(model.pools.values.toList()
                      ..sort((a, b) => (a.TVL ?? 0) < (b.TVL ?? 0)
                          ? 1
                          : (a.TVL ?? 0) > (b.TVL ?? 0)
                              ? -1
                              : 0))
                    .map((pool) => Container(
                        margin: EdgeInsets.symmetric(
                            vertical: AppLayout.getHeight(3),
                            horizontal: AppLayout.getWidth(5)),
                        decoration: ShapeDecoration(
                          color: Color(0xFF505050),
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                            cornerRadius: 15,
                            cornerSmoothing: 1,
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
                          child: ClipSmoothRect(
                            radius: SmoothBorderRadius(
                              cornerRadius: 10,
                              cornerSmoothing: 1,
                            ),
                            child: Stack(children: [
                              //Pool App Icon
                              Container(
                                padding: EdgeInsets.all(AppLayout.getHeight(5)),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA0A0A0),
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
                                      Text(protocolMap[pool.protocol]
                                              ?.shortName ??
                                          '')
                                    ]),
                              ),
                              //End PAI

                              Container(
                                padding: EdgeInsets.only(
                                    top: AppLayout.getHeight(35),
                                    bottom: AppLayout.getHeight(10),
                                    left: AppLayout.getWidth(7),
                                    right: AppLayout.getWidth(7)),
                                child: Row(children: [
                                  SizedBox(
                                      width: 30,
                                      child: getASAiconWidget(
                                          model.asaIconList, pool.asset_1_id)),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                      width: 30,
                                      child: getASAiconWidget(
                                          model.asaIconList, pool.asset_2_id)),
                                  // const SizedBox(width: 10),
                                  Expanded(
                                      flex: 8,
                                      child: Text(
                                          "  ${pool.asset_1_unit_name} / ${pool.asset_2_unit_name}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600))),
                                  Flexible(
                                      flex: 7,
                                      fit: FlexFit.tight,
                                      child: Row(children: [
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    pool.TVL != null
                                                        ? '\$${formatNumber(pool.TVL)}'
                                                        : '-',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF25CED1),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400)))),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    pool.APY != null
                                                        ? "${(pool.APY! * 100).toStringAsFixed(2)}%"
                                                        : "-",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400))))
                                      ]))
                                ]),
                              )
                            ]),
                          ),
                        )))
              ].toList()),
        ),
      );
    });
  }
}
