import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_model.dart';
import '../../../helper.dart';

class PositionsView extends StatelessWidget {
  const PositionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return ListView(children: [
        ...model.positions.map((position) => Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(children: [
                  Row(children: [
                    SizedBox(
                        width: 24,
                        child: getASAiconWidget(
                            model.asaIconList, position.asset_1_id)),
                    const SizedBox(width: 5),
                    SizedBox(
                        width: 24,
                        child: getASAiconWidget(
                            model.asaIconList, position.asset_2_id)),
                    const SizedBox(width: 15),
                    Text(
                        "${model.assets[position.asset_1_id]?.params.unitName}/${model.assets[position.asset_2_id]?.params.unitName} on ${protocolMap[position.protocol]?.name}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700))
                  ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Underlying assets",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 3),
                              Row(children: [
                                Text(
                                    "${position.asset_1_amount.toStringAsFixed(2)} ${model.assets[position.asset_1_id]?.params.unitName}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 10),
                                Text(
                                    "${position.asset_2_amount.toStringAsFixed(2)} ${model.assets[position.asset_2_id]?.params.unitName}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500))
                              ])
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Market value",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 3),
                              Text(
                                  "US\$ ${position.marketValue.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                            ])
                      ])
                ]))))
      ]);
    });
  }
}
