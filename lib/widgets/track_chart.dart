import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';

List<Map<String, dynamic>> assetHoldings = [
  {'key': 0, 'token': 'USDC', 'quantity': 200, 'usd_val': 199.9},
  {'key': 1, 'token': 'ALGO', 'quantity': 400, 'usd_val': 100},
  {'key': 2, 'token': 'rUFt', 'quantity': 1200, 'usd_val': 30},
  {'key': 3, 'token': 'gALGO', 'quantity': 55, 'usd_val': 160.5},
  {'key': 4, 'token': 'NURD', 'quantity': 2040, 'usd_val': 23},
  {'key': 5, 'token': 'GIL0001', 'quantity': 1, 'usd_val': 2},
  {'key': 6, 'token': 'GIL0002', 'quantity': 1, 'usd_val': 0},
];

List<Color> chartColors = [
  const Color(0xFFEA526F),
  const Color(0xFFFF8A5B),
  const Color(0xFFFCEADE),
  const Color(0xFF25CED1),
  const Color(0xFFBBE6E4)
];

//top 5 assets
assetHoldingsOrder() {
  var sortedAssetHoldings = assetHoldings;
  sortedAssetHoldings.sort((a, b) => (b['usd_val'].compareTo(a['usd_val'])));

  if (sortedAssetHoldings.length <= 5) {
    return sortedAssetHoldings;
  } else {
    sortedAssetHoldings.removeRange(5, sortedAssetHoldings.length);
    return sortedAssetHoldings;
  }
}

//sum of top 5 assets
sumOfAssets() {
  double sumOfAssets = 0.0;
  assetHoldingsOrder().forEach((asset) {
    sumOfAssets += asset['usd_val'];
  });
  return sumOfAssets;
}

//number of elements less than 5% of sumOfAssets
lessThanPercent() {
  var lessThanPercent = 0;
  assetHoldingsOrder().forEach((element) {
    element['usd_val'] / sumOfAssets() <= 0.05
        ? lessThanPercent++
        : lessThanPercent;
  });
  return lessThanPercent;
}

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
    var sortedAssetHoldings = assetHoldingsOrder();

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
                    .map<Widget>(
                      (asset) => SizedBox(
                        width: chartWidth * asset['usd_val'] / sumOfAssets(),
                        child: Container(
                          color: asset['usd_val'] / sumOfAssets() <= 0.05
                              ? const Color(0xFF084B83)
                              : chartColors[asset['key']],
                        ),
                      ),
                    )
                    .toList())),
        Positioned(
          top: chartHeight * 1.45,
          left: 15,
          width: chartWidth,
          height: chartHeight + 10,
          child: Row(
            children: sortedAssetHoldings
                .map<Widget>(
                  (asset) => SizedBox(
                    // width: chartWidth,
                    // height: chartHeight + 50,
                    width: (asset['usd_val'] / sumOfAssets()) * chartWidth,

                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: (asset['usd_val'] / sumOfAssets()) >= 0.05
                          ? [
                              SizedBox(
                                height: 30,
                                width: 1,
                                child:
                                    Container(color: const Color(0xFF494952)),
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
                                  asset['token'].toString(),
                                  style: const TextStyle(
                                      color: Color(0xFFA0A0A0),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ]

                          //If the asset is less than 5% and is last, an ellipsis will show
                          : (asset == sortedAssetHoldings.last
                              ? [
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                          height: 20,
                                          width: 1,
                                          child: Container(
                                              color: const Color(0xFF494952))),
                                      const Positioned(
                                          top: 15,
                                          width: 20,
                                          child: Text("…",
                                              style: TextStyle(
                                                  color: Color(0xFFA0A0A0))))
                                    ],
                                  ),
                                ]
                              : [const Text('')]),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
