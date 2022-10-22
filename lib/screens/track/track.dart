import 'package:flutter/material.dart';
import 'package:uf_flutter_app/widgets/track_chart.dart';
import '../../utils/app_layout.dart';
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
      return Scaffold(
          appBar: AppBar(title: const ConnectWallet()),
          body: Column(children: [
            Padding(
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
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
            _selectedIndex == 0 ? const TrackChart() : const Text(""),
            const SizedBox(
              height: 50,
            ),
            Expanded(
                child: ShaderMask(
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
                  stops: [0.0, 0.02, 0.9, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstOut,
              child: Expanded(
                child: choices[_selectedIndex].choiceWidget,
              ),
            )),
          ]));
    });
  }
}
