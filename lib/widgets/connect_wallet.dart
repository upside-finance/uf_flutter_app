import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_model.dart';
import '../helper.dart';

class ConnectWallet extends StatefulWidget {
  const ConnectWallet({super.key});

  @override
  State<ConnectWallet> createState() => ConnectWalletState();
}

class ConnectWalletState extends State<ConnectWallet> {
  String inputAddress = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 15),
            ),
            onPressed: () {
              model.fbAnalytics?.logEvent(name: "Buy NFT click");
              launchUrl(Uri.parse(
                  'https://instantshuffle.com/shuffle/6ljm0bXK9UEaSChJ1v7S'));
            },
            child: const Text("BUY NFT")),
        TextButton(
            onPressed: () {
              if (model.userAddress == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Input wallet address'),
                        content: TextField(
                            onChanged: (text) {
                              inputAddress = text;
                            },
                            decoration: const InputDecoration(
                                hintText: 'E.g. 7BZEUI...')),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Provider.of<AppModel>(context, listen: false)
                                    .setUserAddress(inputAddress);
                                Navigator.pop(context, 'OK');
                                model.fbAnalytics?.logEvent(
                                    name: "Connect wallet",
                                    parameters: {
                                      "Input address": inputAddress
                                    });
                              },
                              child: const Text('OK'))
                        ],
                      );
                    });
              } else {
                Provider.of<AppModel>(context, listen: false)
                    .disconnectWallet();
              }
            },
            child: Row(children: [
              const Icon(Icons.account_balance_wallet_outlined),
              model.userAddress == null
                  ? const SizedBox(width: 3)
                  : Text(getAbbreviatedAddress(model.userAddress!)),
              if (model.userAddress == null) const Text("CONNECT WALLET")
            ])),
        // if (model.userAddress != null)
        //   Text(getAbbreviatedAddress(model.userAddress!))
      ]);
    });
  }
}
