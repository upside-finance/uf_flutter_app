import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppModel extends ChangeNotifier {
  final Map<String, dynamic> pools = {};
  final Map<String, dynamic> assets = {};
  Map<String, dynamic> asaIconList = {};

  void fetchASAiconList() async {
    final response =
        await http.get(Uri.parse('https://asa-list.tinyman.org/assets.json'));

    if (response.statusCode == 200) {
      asaIconList = jsonDecode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load ASA icon list');
    }
  }

  void fetchTMPools() async {
    final response = await http.get(Uri.parse(
        'https://mainnet.analytics.tinyman.org/api/v1/pools/?limit=all&with_statistics=true&verified_only=true&ordering=-liquidity'));

    if (response.statusCode == 200) {
      jsonDecode(response.body)['results'].forEach((pool) {
        if (pool['address'] == null ||
            pool['asset_1'] == null ||
            pool['asset_2'] == null ||
            pool['liquidity_asset'] == null) {
          return;
        }

        var address = pool['address'];
        var asset_1 = pool['asset_1'];
        var asset_2 = pool['asset_2'];
        var liquidityAsset = pool['liquidity_asset'];

        pools[address] = pool;
        pools[address]['asset_1'] = asset_1['id'];
        pools[address]['asset_2'] = asset_2['id'];
        pools[address]['liquidityAsset'] = liquidityAsset['id'];

        assets[asset_1['id']] = asset_1;
        assets[asset_2['id']] = asset_2;
        assets[liquidityAsset['id']] = liquidityAsset;
      });

      notifyListeners();
    } else {
      throw Exception('Failed to load Tinyman pools');
    }
  }
}
