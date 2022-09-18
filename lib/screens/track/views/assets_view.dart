import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_model.dart';
import '../../../helper.dart';

class AssetsView extends StatelessWidget {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return ListView(children: [
        ...?model.accountInformation?.assets.map((assetHolding) {
          final asset = model.assets[assetHolding.assetId];
          final assetParams = asset?.params;

          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
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
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                              "${assetAmountToScaled(assetHolding.amount, assetParams?.decimals).toStringAsFixed(3)} ${assetParams?.unitName}")
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
                                  fontSize: 16, fontWeight: FontWeight.w700))
                        ])),
                const SizedBox(width: 10)
              ]));
        })
      ]);
    });
  }
}
