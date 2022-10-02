import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:algorand_dart/algorand_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './helper.dart';

enum Protocol { tinyman, pact }

const Map<Protocol, ProtocolDetail> protocolMap = {
  Protocol.tinyman: ProtocolDetail(
      name: "Tinyman",
      shortName: "TM",
      logoURI: "assets/images/tinyman_app_icon.png"),
  Protocol.pact: ProtocolDetail(
      name: "PactFi",
      shortName: "PF",
      logoURI: "assets/images/pactfi_app_icon.png")
};

class ProtocolDetail {
  final String name;
  final String shortName;
  final String logoURI;

  const ProtocolDetail(
      {required this.name, required this.shortName, required this.logoURI});
}

class Pool {
  final String address;
  final int? appID;

  final int asset_1_id;
  final String asset_1_unit_name;

  final int asset_2_id;
  final String asset_2_unit_name;

  final int liquidity_asset_id;
  final String liquidity_asset_unit_name;

  final double? TVL;
  final double? APY;

  final Protocol protocol;

  String genAddLiquidityLink() {
    if (protocol == Protocol.tinyman) {
      return "https://app.tinyman.org/#/pool/add-liquidity?asset_1=$asset_1_id&asset_2=$asset_2_id";
    } else if (protocol == Protocol.pact) {
      return "https://app.pact.fi/zap/$appID";
    } else {
      return "";
    }
  }

  const Pool({
    required this.address,
    required this.asset_1_id,
    required this.asset_1_unit_name,
    required this.asset_2_id,
    required this.asset_2_unit_name,
    required this.liquidity_asset_id,
    required this.liquidity_asset_unit_name,
    required this.protocol,
    this.TVL,
    this.APY,
    this.appID,
  });
}

class LPposition {
  final double marketValue;

  final double poolShare;

  final int asset_1_id;
  final double asset_1_amount;
  final double asset_1_in_usd;

  final int asset_2_id;
  final double asset_2_amount;
  final double asset_2_in_usd;

  final Protocol protocol;

  const LPposition(
      {required this.marketValue,
      required this.poolShare,
      required this.asset_1_id,
      required this.asset_1_amount,
      required this.asset_1_in_usd,
      required this.asset_2_id,
      required this.asset_2_amount,
      required this.asset_2_in_usd,
      required this.protocol});
}

final algoAsset = Asset(
    index: 0,
    params: AssetParameters(
        decimals: 6,
        creator: "",
        total: 10000000000,
        name: "Algo",
        unitName: "ALGO"),
    createdAtRound: 0,
    deleted: false);

class AppModel extends ChangeNotifier {
  SharedPreferences? prefs;
  final Map<String, Pool> pools = {};
  final Map<int, Asset> assets = {0: algoAsset};
  final Map<int, double> assetPrices = {};
  Map<String, dynamic> asaIconList = {};
  List<LPposition> positions = [];
  AccountInformation? accountInformation;
  String? userAddress;

  static const apiKey =
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
  final algodClient =
      AlgodClient(apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL, apiKey: apiKey);
  final indexerClient = IndexerClient(
      apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL, apiKey: apiKey);
  late Algorand algorand;

  AppModel() {
    algorand = Algorand(
      algodClient: algodClient,
      indexerClient: indexerClient,
    );
  }

  void init() async {
    fetchTMPools();
    fetchASAiconList();
    await Future.wait([fetchAssetPrices(), fetchPactPools()]);
    setUserAddressFromSaved();
  }

  void setUserAddressFromSaved() async {
    prefs = await SharedPreferences.getInstance();
    String? savedUserAddress = prefs?.getString('userAddress');
    savedUserAddress != null ? setUserAddress(savedUserAddress) : null;
  }

  void setUserAddress(String inputAddress) {
    userAddress = inputAddress;
    prefs?.setString('userAddress', inputAddress);
    notifyListeners();
    fetchAccountInfo().then((_) {
      fetchTMPositions();
      fetchPFpositions();
    });
  }

  Future<void> fetchAccountInfo() async {
    if (userAddress != null) {
      try {
        accountInformation = await algorand.getAccountByAddress(userAddress!);
        await Future.wait([
          ...?accountInformation?.assets
              .map((assetHolding) => fetchAsset(assetHolding.assetId))
        ]);

        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> fetchAsset(int id) async {
    if (!assets.containsKey(id)) {
      final assetResponse = await algorand.indexer().getAssetById(id);
      assets[assetResponse.asset.index] = assetResponse.asset;
    }
  }

  void fetchTMPositions() async {
    await Future.wait([
      ...?accountInformation?.assets.map((assetHolding) async {
        String? creatorAdd = assets[assetHolding.assetId]?.params.creator;

        final acctInfo = await algorand.getAccountByAddress(creatorAdd ?? '');

        for (var appLocalState in acctInfo.appsLocalState) {
          if (appLocalState.id == 552635992) {
            var parsedLocalState = convertTKVtoMap(appLocalState.keyValue);

            var asset_1_id = parsedLocalState["a1"];
            var asset_2_id = parsedLocalState["a2"];

            await Future.wait([fetchAsset(asset_1_id), fetchAsset(asset_2_id)]);

            var asset_1_reserves = parsedLocalState["s1"];
            var asset_2_reserves = parsedLocalState["s2"];
            var issued_liquidity = parsedLocalState["ilt"];

            double poolShare = assetHolding.amount / issued_liquidity;

            double asset_1_amount = assetAmountToScaled(
                poolShare * asset_1_reserves,
                assets[asset_1_id]?.params.decimals);
            double asset_2_amount = assetAmountToScaled(
                poolShare * asset_2_reserves,
                assets[asset_2_id]?.params.decimals);

            double asset_1_in_usd =
                asset_1_amount * (assetPrices[asset_1_id] ?? 0);
            double asset_2_in_usd =
                asset_2_amount * (assetPrices[asset_2_id] ?? 0);

            double marketValue = asset_1_in_usd + asset_2_in_usd;

            positions.add(LPposition(
                marketValue: marketValue,
                poolShare: poolShare,
                asset_1_id: asset_1_id,
                asset_1_amount: asset_1_amount,
                asset_1_in_usd: asset_1_in_usd,
                asset_2_id: asset_2_id,
                asset_2_amount: asset_2_amount,
                asset_2_in_usd: asset_2_in_usd,
                protocol: Protocol.tinyman));
          }
        }
      })
    ]);

    notifyListeners();
  }

  void fetchPFpositions() async {
    await Future.wait([
      ...?accountInformation?.assets.map((assetHolding) async {
        final assetCreator = assets[assetHolding.assetId]?.params.creator;

        if (pools.containsKey(assetCreator) &&
            pools[assetCreator]?.protocol == Protocol.pact) {
          final appRes = await algorand
              .indexer()
              .getApplicationById((pools[assetCreator]?.appID)!);

          var rawGlobalState = appRes.application?.params.globalState;

          if (rawGlobalState != null) {
            var globalState = convertTKVtoMap(rawGlobalState);

            var asset_1_id = (pools[assetCreator]?.asset_1_id)!;
            var asset_2_id = (pools[assetCreator]?.asset_2_id)!;

            await Future.wait([fetchAsset(asset_1_id), fetchAsset(asset_2_id)]);

            var asset_1_reserves = globalState["A"];
            var asset_2_reserves = globalState["B"];
            var issued_liquidity = globalState["L"];

            double poolShare = assetHolding.amount / issued_liquidity;

            double asset_1_amount = assetAmountToScaled(
                poolShare * asset_1_reserves,
                assets[asset_1_id]?.params.decimals);
            double asset_2_amount = assetAmountToScaled(
                poolShare * asset_2_reserves,
                assets[asset_2_id]?.params.decimals);

            double asset_1_in_usd =
                asset_1_amount * (assetPrices[asset_1_id] ?? 0);
            double asset_2_in_usd =
                asset_2_amount * (assetPrices[asset_2_id] ?? 0);

            double marketValue = asset_1_in_usd + asset_2_in_usd;

            positions.add(LPposition(
                marketValue: marketValue,
                poolShare: poolShare,
                asset_1_id: asset_1_id,
                asset_1_amount: asset_1_amount,
                asset_1_in_usd: asset_1_in_usd,
                asset_2_id: asset_2_id,
                asset_2_amount: asset_2_amount,
                asset_2_in_usd: asset_2_in_usd,
                protocol: Protocol.pact));
          }
        }
      })
    ]);

    notifyListeners();
  }

  Future<void> fetchAssetPrices() async {
    try {
      final TMresponse = await http.get(Uri.parse(
          'https://mainnet.analytics.tinyman.org/api/v1/assets/prices/'));

      if (TMresponse.statusCode == 200) {
        final TMassetPricesJSON = jsonDecode(TMresponse.body);
        TMassetPricesJSON.keys.forEach((assetID) =>
            assetPrices[int.parse(assetID)] =
                double.parse(TMassetPricesJSON[assetID]['price_in_usd']));

        final PFresponse = await http.get(
            Uri.parse('https://api.pact.fi/api/assets/all?ordering=-tvl_usd'));

        if (PFresponse.statusCode == 200) {
          final PFassetPricesJSON = jsonDecode(PFresponse.body);
          PFassetPricesJSON.forEach((assetDetail) =>
              assetPrices[assetDetail['algoid']] == null &&
                      assetDetail['price'] != null
                  ? (assetPrices[assetDetail['algoid']] =
                      double.parse(assetDetail['price']))
                  : null);
        } else {
          throw Exception(
              'Failed to fetch asset prices from PactFi - Status code ${PFresponse.statusCode}');
        }

        notifyListeners();
      } else {
        throw Exception(
            'Failed to fetch asset prices from Tinyman - Status code ${TMresponse.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchASAiconList() async {
    try {
      final response =
          await http.get(Uri.parse('https://asa-list.tinyman.org/assets.json'));

      if (response.statusCode == 200) {
        asaIconList = jsonDecode(response.body);
        notifyListeners();
      } else {
        throw Exception(
            'Failed to fetch ASA icon list - Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchTMPools() async {
    try {
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

          pools[pool['address']] = Pool(
              address: pool['address'],
              asset_1_id: int.parse(pool['asset_1']['id']),
              asset_1_unit_name: pool['asset_1']['unit_name'],
              asset_2_id: int.parse(pool['asset_2']['id']),
              asset_2_unit_name: pool['asset_2']['unit_name'],
              liquidity_asset_id: int.parse(pool['liquidity_asset']['id']),
              liquidity_asset_unit_name: pool['liquidity_asset']['unit_name'],
              TVL: pool['liquidity_in_usd'] != null
                  ? double.parse(pool['liquidity_in_usd'])
                  : null,
              APY: pool['annual_percentage_yield'] != null
                  ? double.parse(pool['annual_percentage_yield'])
                  : null,
              protocol: Protocol.tinyman);
        });

        notifyListeners();
      } else {
        throw Exception(
            'Failed to fetch TM pools - Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchPactPools() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.pact.fi/api/pools/all?ordering=-tvl_usd'));

      if (response.statusCode == 200) {
        jsonDecode(response.body).forEach((pool) {
          if (pool['address'] == null ||
              pool['primary_asset'] == null ||
              pool['secondary_asset'] == null ||
              pool['pool_asset'] == null) {
            return;
          }

          pools[pool['address']] = Pool(
              address: pool['address'],
              asset_1_id: pool['secondary_asset']['algoid'],
              asset_1_unit_name: pool['secondary_asset']['unit_name'],
              asset_2_id: pool['primary_asset']['algoid'],
              asset_2_unit_name: pool['primary_asset']['unit_name'],
              liquidity_asset_id: pool['pool_asset']['algoid'],
              liquidity_asset_unit_name: pool['pool_asset']['unit_name'],
              protocol: Protocol.pact,
              TVL: pool['tvl_usd'] != null
                  ? double.parse(pool['tvl_usd'])
                  : null,
              APY: pool['apr_7d_all'] != null
                  ? double.parse(pool['apr_7d_all'])
                  : null,
              appID: pool['appid']);
        });

        notifyListeners();
      } else {
        throw Exception(
            'Failed to fetch Pact Fi pools - Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
