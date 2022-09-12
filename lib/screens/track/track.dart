import 'package:flutter/material.dart';
import '../../widgets/connect_wallet.dart';
import './test.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => TrackScreenState();
}

class TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
        child: Column(children: [
          const ConnectWallet(),
          SizedBox(
              height: 500,
              width: 500,
              child: DonutAutoLabelChart.withSampleData()),
        ]));
  }
}
