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
        padding: const EdgeInsets.only(top: 15),
        child: ListView(
            children: [
          const ConnectWallet(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(children: [
                const SizedBox(width: 65),
                const Expanded(flex: 8, child: Text('')),
                Flexible(
                    flex: 7,
                    fit: FlexFit.tight,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                              child: Center(
                                  child: Text(
                            'TVL',
                          ))),
                          SizedBox(width: 15),
                          Expanded(
                              child: Center(
                                  child: Text(
                            'APY[7D]',
                          )))
                        ]))
              ])),
          ...(model.pools.values.toList()
                ..sort((a, b) => (a.TVL ?? 0) < (b.TVL ?? 0)
                    ? 1
                    : (a.TVL ?? 0) > (b.TVL ?? 0)
                        ? -1
                        : 0))
              .map((pool) => Card(
                  elevation: 0,
                  child: InkWell(
                    onTap: () => {},
                    child: Stack(children: [
                      Row(children: [
                        const SizedBox(width: 5),
                        SizedBox(
                            width: 15,
                            child: Image.asset(
                                protocolMap[pool.protocol]?.logoURI ?? '')),
                        const SizedBox(width: 3),
                        Text(protocolMap[pool.protocol]?.shortName ?? '')
                      ]),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 5),
                          child: Row(children: [
                            SizedBox(
                                width: 25,
                                child: getASAiconWidget(
                                    model.asaIconList, pool.asset_1_id)),
                            const SizedBox(width: 5),
                            SizedBox(
                                width: 25,
                                child: getASAiconWidget(
                                    model.asaIconList, pool.asset_2_id)),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 8,
                                child: Text(
                                    "${pool.asset_1_unit_name}/${pool.asset_2_unit_name}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))),
                            Flexible(
                                flex: 7,
                                fit: FlexFit.tight,
                                child: Row(children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                              '\$${formatNumber(pool.TVL)}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w700)))),
                                  const SizedBox(width: 15),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                              pool.APY != null
                                                  ? "${(pool.APY! * 100).toStringAsFixed(2)}%"
                                                  : "-",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w700))))
                                ]))
                          ]))
                    ]),
                  )))
        ].toList()),
      );
    });
  }
}
