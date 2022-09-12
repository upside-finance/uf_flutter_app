import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_model.dart';
import './pera_wallet_connect.dart';

class ConnectWallet extends StatefulWidget {
  const ConnectWallet({super.key});

  @override
  State<ConnectWallet> createState() => ConnectWalletState();
}

class ConnectWalletState extends State<ConnectWallet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
            onPressed: () async {
              var pera = PeraWalletConnect();
              var uri = await pera.connect(context);
            },
            icon: const Icon(Icons.account_balance_wallet_outlined))
      ]);
    });
  }
}
