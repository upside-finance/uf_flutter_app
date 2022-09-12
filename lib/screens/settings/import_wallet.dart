import 'package:flutter/material.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  State<ImportWalletScreen> createState() => ImportWalletScreenState();
}

class ImportWalletScreenState extends State<ImportWalletScreen> {
  final List<String> _seedPhrase = List<String>.filled(25, '');

  List<Widget> genSeedFields(int start, int end) {
    return List<int>.generate(end - start + 1, (i) => i + start)
        .map((index) => Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text("$index")),
                Expanded(child: TextField(onChanged: (text) {
                  _seedPhrase[index - 1] = text;
                }))
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Import wallet")),
        body: ListView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: genSeedFields(1, 13),
                        ))),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: genSeedFields(14, 25),
                        )))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: ElevatedButton(
                        onPressed: () => {}, child: const Text("Import")))
              ])
            ]));
  }

  // () => showDialog(
  //                   context: context,
  //                   builder: (BuildContext context) => SimpleDialog(
  //                           title: const Text('Enter seed phrase'),
  //                           children: [
  // Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //           child: Column(
  //         children: genSeedFields(1, 13),
  //       )),
  //       Expanded(
  //           child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: genSeedFields(14, 25),
  //       ))
  //     ])
  //                           ]))
}
