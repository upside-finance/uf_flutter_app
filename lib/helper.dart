import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import 'package:algorand_dart/algorand_dart.dart';
import 'dart:convert';

String formatNumber(dynamic myNumber) {
  // Convert number into a string if it was not a string previously
  String stringNumber = myNumber.toString();

  // Convert number into double to be formatted.
  // Default to zero if unable to do so
  double doubleNumber = double.tryParse(stringNumber) ?? 0;

  // Set number format to use
  NumberFormat numberFormat = NumberFormat.compact();

  return numberFormat.format(doubleNumber);
}

double assetAmountToScaled(num amount, int? decimals) {
  return amount / pow(10, decimals ?? 0);
}

Widget getASAiconWidget(Map<String, dynamic> asaIconList, int? id) {
  if (asaIconList.containsKey('$id')) {
    final String iconURL = 'https://asa-list.tinyman.org/assets/$id/icon.png';
    return CachedNetworkImage(
        imageUrl: iconURL,
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/defaultToken.png'));
  } else {
    return Image.asset('assets/images/defaultToken.png');
  }
}

String getAbbreviatedAddress(String address) {
  return "${address.substring(0, 5)}...${address.substring(address.length - 5, address.length)}";
}

dynamic getValuefromTealKeyValueList(
    List<TealKeyValue> keyvalue, String plainKey) {
  for (var k in keyvalue) {
    if (k.key == base64Encode(utf8.encode(plainKey))) {
      return (k.value.type == 2 ? k.value.uint : k.value.bytes);
    }
  }
}
