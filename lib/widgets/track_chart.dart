import 'package:algorand_dart/algorand_dart.dart';

import '../../app_model.dart';
import 'package:provider/provider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';
import '../../../helper.dart';

// List<Map<String, dynamic>> assetHoldings = [
//   {'key': 0, 'token': 'USDC', 'quantity': 200, 'usd_val': 199.9},
//   {'key': 1, 'token': 'ALGO', 'quantity': 400, 'usd_val': 100},
//   {'key': 2, 'token': 'rUFt', 'quantity': 1200, 'usd_val': 30},
//   {'key': 3, 'token': 'gALGO', 'quantity': 55, 'usd_val': 160.5},
//   {'key': 4, 'token': 'NURD', 'quantity': 2040, 'usd_val': 23},
//   {'key': 5, 'token': 'GIL0001', 'quantity': 1, 'usd_val': 2},
//   {'key': 6, 'token': 'GIL0002', 'quantity': 1, 'usd_val': 0},
// ];

List<Color> chartColors = [
  const Color(0xFFEA526F),
  const Color(0xFFFF8A5B),
  const Color(0xFFFCEADE),
  const Color(0xFF25CED1),
  const Color(0xFFBBE6E4)
];

//top 5 assets
// assetHoldingsOrder() {
//   var sortedAssetHoldings = assetHoldings;
//   sortedAssetHoldings.sort((a, b) => (b['usd_val'].compareTo(a['usd_val'])));

//   if (sortedAssetHoldings.length <= 5) {
//     return sortedAssetHoldings;
//   } else {
//     sortedAssetHoldings.removeRange(5, sortedAssetHoldings.length);
//     return sortedAssetHoldings;
//   }
// }

//sum of top 5 assets
sumOfAssets(List<AssetHolding>? assetHoldings, Map<int, double> assetPrices,
    Map<int, Asset> assets) {
  return assetHoldings?.fold<double>(
          0,
          (sum, assetHolding) =>
              sum + getUSDvalue(assetHolding, assetPrices, assets)) ??
      0;
}

double getUSDvalue(AssetHolding assetHolding, Map<int, double> assetPrices,
    Map<int, Asset> assets) {
  return assetAmountToScaled(
          assetHolding.amount, assets[assetHolding.assetId]?.params.decimals) *
      (assetPrices[assetHolding.assetId] ?? 0);
}

//number of elements less than 5% of sumOfAssets
// lessThanPercent() {
//   var lessThanPercent = 0;
//   assetHoldingsOrder().forEach((element) {
//     element['usd_val'] / sumOfAssets() <= 0.05
//         ? lessThanPercent++
//         : lessThanPercent;
//   });
//   return lessThanPercent;
// }

final double chartWidth = AppLayout.getWidth(350);
final double chartHeight = AppLayout.getHeight(45);

class TrackChart extends StatefulWidget {
  const TrackChart({super.key});

  @override
  State<TrackChart> createState() => _TrackChartState();
}

class _TrackChartState extends State<TrackChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      var sortedAssetHoldings = (model.accountInformation?.assets
            ?..sort((a, b) => getUSDvalue(a, model.assetPrices, model.assets) <
                    getUSDvalue(b, model.assetPrices, model.assets)
                ? 1
                : 0))
          ?.take(5)
          .toList();

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              height: chartHeight,
              width: chartWidth,
              margin: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(20),
                  horizontal: AppLayout.getWidth(15)),
              decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderAlign: BorderAlign.inside,
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 12,
                      cornerSmoothing: 0.5,
                    ),
                  ),
                  shadows: const [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 1,
                        spreadRadius: 1,
                        blurStyle: BlurStyle.inner)
                  ]),
              clipBehavior: Clip.hardEdge,
              child: Row(
                  children: sortedAssetHoldings
                          ?.asMap()
                          .map(
                            (i, assetHolding) => MapEntry(
                                i,
                                SizedBox(
                                  width: chartWidth *
                                      getUSDvalue(assetHolding,
                                          model.assetPrices, model.assets) /
                                      sumOfAssets(
                                          model.accountInformation?.assets,
                                          model.assetPrices,
                                          model.assets),
                                  child: Container(
                                    color: getUSDvalue(
                                                    assetHolding,
                                                    model.assetPrices,
                                                    model.assets) /
                                                sumOfAssets(
                                                    model.accountInformation
                                                        ?.assets,
                                                    model.assetPrices,
                                                    model.assets) <=
                                            0.05
                                        ? const Color(0xFF084B83)
                                        : chartColors[i],
                                  ),
                                )),
                          )
                          .values
                          .toList() ??
                      [])),
          Positioned(
            top: chartHeight * 1.45,
            left: 15,
            width: chartWidth,
            height: chartHeight + 10,
            child: Row(
              children: [
                ...?sortedAssetHoldings
                    ?.map<Widget>(
                      (assetHolding) => SizedBox(
                        // width: chartWidth,
                        // height: chartHeight + 50,
                        width: (getUSDvalue(assetHolding, model.assetPrices,
                                    model.assets) /
                                sumOfAssets(model.accountInformation?.assets,
                                    model.assetPrices, model.assets)) *
                            chartWidth,

                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: (getUSDvalue(assetHolding,
                                          model.assetPrices, model.assets) /
                                      sumOfAssets(
                                          model.accountInformation?.assets,
                                          model.assetPrices,
                                          model.assets)) >=
                                  0.05
                              ? [
                                  SizedBox(
                                    height: 30,
                                    width: 1,
                                    child: Container(
                                        color: const Color(0xFF494952)),
                                  ),
                                  SizedBox(
                                    height: 6,
                                    width: 6,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF494952),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      model.assets[assetHolding.assetId]?.params
                                              .unitName ??
                                          '',
                                      style: const TextStyle(
                                          color: Color(0xFFA0A0A0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ]

                              //If the asset is less than 5% and is last, an ellipsis will show
                              : (assetHolding == sortedAssetHoldings.last
                                  ? [
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          SizedBox(
                                              height: 20,
                                              width: 1,
                                              child: Container(
                                                  color:
                                                      const Color(0xFF494952))),
                                          const Positioned(
                                              top: 15,
                                              width: 20,
                                              child: Text("…",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFFA0A0A0))))
                                        ],
                                      ),
                                    ]
                                  : [const Text('')]),
                        ),
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ],
      );
    });
  }
}
