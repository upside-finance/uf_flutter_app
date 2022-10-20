import 'package:flutter/material.dart';
import '../../widgets/connect_wallet.dart';
import 'package:provider/provider.dart';
import '../../app_model.dart';
import './views/assets_view.dart';
import './views/positions_view.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => TrackScreenState();
}

class TrackChoice {
  final String choiceName;
  final Widget choiceWidget;

  const TrackChoice({required this.choiceName, required this.choiceWidget});
}

class TrackScreenState extends State<TrackScreen> {
  int _selectedIndex = 0;
  static const List<TrackChoice> choices = [
    TrackChoice(choiceName: 'Assets', choiceWidget: AssetsView()),
    TrackChoice(choiceName: 'Positions', choiceWidget: PositionsView()),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
          child: Column(children: [
            const ConnectWallet(),
            // LimitedBox(
            //     maxHeight: 200,
            //     child: Row(children: [
            //       Expanded(child: DonutAutoLabelChart.withSampleData())
            //     ])),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text('Display: '),
                const SizedBox(width: 5),
                ...choices
                    .asMap()
                    .entries
                    .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChoiceChip(
                            selected: _selectedIndex == entry.key,
                            onSelected: (_) {
                              model.fbAnalytics?.logEvent(
                                  name: "Track page view select",
                                  parameters: {"View": entry.value.choiceName});
                              setState(() {
                                _selectedIndex = entry.key;
                              });
                            },
                            label: Text(entry.value.choiceName))))
                    .toList(),
              ],
            ),
            Expanded(child: choices[_selectedIndex].choiceWidget),
          ]));
    });
  }
}
