import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../../app_model.dart';

class PeraWalletConnect {
  String _bridge = '';
  WalletConnect? _connector;

  Future<String> getBridgeURL() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingBridge = prefs.getString('PeraWallet.BridgeURL');

    if (existingBridge != null) {
      return existingBridge;
    }

    final response =
        await http.get(Uri.parse("https://wc.perawallet.app/servers.json"));

    if (response.statusCode == 200) {
      var serverURLs = jsonDecode(response.body)['servers'];
      var selectedURL = serverURLs[Random().nextInt(serverURLs.length)];
      await prefs.setString('PeraWallet.BridgeURL', selectedURL);

      return selectedURL;
    } else {
      throw Exception('Failed to load Pera Wallet bridge server URLs');
    }
  }

  Uri generatePeraWalletAppDeepLink(String uri) {
    if ((kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ||
        (!kIsWeb && Platform.isIOS)) {
      return Uri(
          scheme: 'algorand-wc', host: 'wc', queryParameters: {'uri': uri});
    } else {
      return Uri.parse(uri);
    }
  }

  connect(BuildContext context) async {
    if (_connector?.connected ?? false) {
      await _connector?.killSession();
    }

    _bridge = await getBridgeURL();

    _connector = WalletConnect(
        bridge: _bridge,
        clientMeta: const PeerMeta(
          name: 'UpsideFinance',
          description: 'UpsideFinance mobile wallet',
          url: 'https://upsidefinance.io/',
          icons: [
            'https://pbs.twimg.com/profile_images/1598063211999367175/7KQ6aBQv_400x400.jpg'
          ],
        ));

    final sessionStatus = await _connector?.createSession(
        chainId: 4160,
        onDisplayUri: (uri) {
          launchUrl(generatePeraWalletAppDeepLink(uri));

          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         // return SimpleDialog(title: Text(link.toString()));
          //         return Column(children: [
          //           Text(link.toString()),
          //           Container(
          //               decoration: const BoxDecoration(color: Colors.amber),
          //               child: QrImage(
          //                 data: link.toString(),
          //                 version: QrVersions.auto,
          //                 size: 200.0,
          //               ))
          //         ]);
          // });
        });

    if (sessionStatus?.accounts[0] != null) {
      Provider.of<AppModel>(context, listen: false)
          .setUserAddress((sessionStatus?.accounts[0])!);
    }
  }
}
