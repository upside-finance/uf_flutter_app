import 'package:flutter/material.dart';
import './import_wallet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 40),
        child: Column(children: [
          Card(
            child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ImportWalletScreen())),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 15),
                    child: Row(children: [
                      Expanded(
                          child: Row(
                        children: const [
                          Icon(Icons.account_balance_wallet),
                          Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Import wallet',
                                  style: TextStyle(fontSize: 20)))
                        ],
                      )),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 18)
                    ]))),
          ),
        ]));
  }
}
