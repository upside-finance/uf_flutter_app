import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';
import '../../../app_model.dart';
import '../../../helper.dart';

class AssetsView extends StatelessWidget {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      model.fbAnalytics?.setCurrentScreen(screenName: "Track - Assets");

      return ListView(children: [
        const SizedBox(
          height: 30,
        ),
        ...?model.accountInformation?.assets.map(
          (assetHolding) {
            final asset = model.assets[assetHolding.assetId];
            final assetParams = asset?.params;

            return Column(children: [
              const SizedBox(
                height: 15,
              ),
              Row(children: [
                const SizedBox(width: 10),
                SizedBox(
                    width: 35,
                    child: getASAiconWidget(model.asaIconList, asset?.index)),
                const SizedBox(width: 15),
                Expanded(
                    flex: 8,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${assetParams?.name}",
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            "${assetAmountToScaled(assetHolding.amount, assetParams?.decimals).toStringAsFixed(3)} ${assetParams?.unitName}",
                            style: const TextStyle(color: Color(0xFF25CED1)),
                          )
                        ])),
                Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              "US\$ ${(assetAmountToScaled(assetHolding.amount, assetParams?.decimals) * (model.assetPrices[asset?.index] ?? 0)).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300))
                        ])),
                const SizedBox(width: 10)
              ]),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 0.2,
                width: double.infinity,
                color: Colors.white,
                margin:
                    EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              )
            ]);
          },
        ),
        const SizedBox(
          height: 30,
        ),
      ]);
    });
  }
}
