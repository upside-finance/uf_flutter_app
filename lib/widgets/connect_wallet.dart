import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uf_flutter_app/utils/app_layout.dart';
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
              textStyle: const TextStyle(fontSize: 12),
            ),
            onPressed: () {
              model.fbAnalytics?.logEvent(name: "Buy NFT click");
              launchUrl(Uri.parse(
                  'https://instantshuffle.com/shuffle/6ljm0bXK9UEaSChJ1v7S'));
            },
            child: const Text("BUY NFT")),
        TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
            onPressed: () {
              if (model.userAddress == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Input wallet address'),
                        backgroundColor: const Color(0xFF505050),
                        elevation: 20,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 22, cornerSmoothing: 1)),
                        content: TextField(
                          style: const TextStyle(color: Color(0xFF161616)),
                          onChanged: (text) {
                            inputAddress = text;
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                            hintText: 'E.g. 7BZEUI...',
                            hintStyle: TextStyle(color: Color(0xFFA0A0A0)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              )),
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
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      );
                    });
              } else {
                Provider.of<AppModel>(context, listen: false)
                    .disconnectWallet();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(8),
                  horizontal: AppLayout.getWidth(9)),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFF505050),
              ),
              child: Row(children: [
                const FaIcon(
                  FontAwesomeIcons.wallet,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 7,
                ),
                model.userAddress == null
                    ? const SizedBox(width: 3)
                    : Text(
                        getAbbreviatedAddress(model.userAddress!),
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                if (model.userAddress == null)
                  const Text(
                    "Connect Wallet",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  )
              ]),
            )),
        // if (model.userAddress != null)
        //   Text(getAbbreviatedAddress(model.userAddress!))
      ]);
    });
  }
}
