import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_model.dart';
import '../../helper.dart';
import '../../widgets/connect_wallet.dart';

class InvestScreen extends StatefulWidget {
  const InvestScreen({super.key});

  @override
  State<InvestScreen> createState() => InvestScreenState();
}

class InvestScreenState extends State<InvestScreen> {
  @override
  void initState() {
    Provider.of<AppModel>(context, listen: false).fetchTMPools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
        child: ListView(
            children: [
          const ConnectWallet(),
          ...model.pools.values.map((pool) => Row(children: [
                Expanded(
                    child: Card(
                        child: InkWell(
                  onTap: () => {},
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 15),
                      child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: getASAiconWidget(
                                    model.asaIconList, pool['asset_1'])),
                            Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: getASAiconWidget(
                                    model.asaIconList, pool['asset_2'])),
                            Expanded(
                                child: Text(
                                    model.assets[pool['asset_1']]['unit_name'] +
                                        ' / ' +
                                        model.assets[pool['asset_2']]
                                            ['unit_name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))),
                            Row(children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Column(children: [
                                    const Text('TVL',
                                        style: TextStyle(fontSize: 12)),
                                    Text(
                                        '\$${formatNumber(pool['liquidity_in_usd'])}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700))
                                  ])),
                              Column(children: [
                                const Text('APY[7D]',
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                    formatNumber(double.parse(pool[
                                                    'annual_percentage_rate'] ??
                                                '0') *
                                            100) +
                                        '%',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))
                              ])
                            ])
                          ])),
                )))
              ]))
        ].toList()),
      );
    });
  }
}
