import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

formatNumber(dynamic myNumber) {
  // Convert number into a string if it was not a string previously
  String stringNumber = myNumber.toString();

  // Convert number into double to be formatted.
  // Default to zero if unable to do so
  double doubleNumber = double.tryParse(stringNumber) ?? 0;

  // Set number format to use
  NumberFormat numberFormat = NumberFormat.compact();

  return numberFormat.format(doubleNumber);
}

Widget getASAiconWidget(Map<String, dynamic> asaIconList, String id) {
  if (asaIconList.containsKey(id)) {
    final String iconURL = 'https://asa-list.tinyman.org/assets/$id/icon.png';
    return CachedNetworkImage(
        width: 24,
        imageUrl: iconURL,
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/defaultToken.png', width: 24));
  } else {
    return Image.asset('assets/images/defaultToken.png', width: 24);
  }
}
