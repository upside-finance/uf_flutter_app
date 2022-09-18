import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Input wallet address'),
                      content: TextField(onChanged: (text) {
                        inputAddress = text;
                      }),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              Provider.of<AppModel>(context, listen: false)
                                  .setUserAddress(inputAddress);
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.account_balance_wallet_outlined)),
        if (model.userAddress != null)
          Text(getAbbreviatedAddress(model.userAddress!))
      ]);
    });
  }
}
