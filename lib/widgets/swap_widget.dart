import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_layout.dart';
import '../utils/token_list.dart';

class SwapWidget extends StatefulWidget {
  final String swap;
  const SwapWidget({super.key, required this.swap});

  @override
  State<SwapWidget> createState() => _SwapWidgetState();
}

class _SwapWidgetState extends State<SwapWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        Container(
          height: AppLayout.getHeight(80),
          padding: EdgeInsets.all(AppLayout.getHeight(10)),
          margin: EdgeInsets.symmetric(vertical: AppLayout.getHeight(2)),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
                  child: widget.swap == "from"
                      ? const TextField(
                          enabled: true,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration.collapsed(
                            hintText: "0.00",
                          ),
                        )
                      : const TextField(
                          enabled: false,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration.collapsed(
                            hintText: "0.00",
                          ),
                        )),
              Container(
                width: 120,
                height: 35,
                child: DropdownSearch<TokenList>(
                  // items: tokenList,
                  asyncItems: (filter) => getData(filter),
                  popupProps: PopupProps.dialog(
                    //constraints: const BoxConstraints(),
                    itemBuilder: _customPopupItemBuilder,
                    showSearchBox: true,
                    showSelectedItems: false,
                    dialogProps: DialogProps(
                        contentPadding: const EdgeInsets.all(5),
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 22, cornerSmoothing: 1))),
                    searchFieldProps: const TextFieldProps(
                        //padding: EdgeInsets.all(20),
                        style: TextStyle(
                          color: Color(0xFF161616),
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            labelStyle: TextStyle(color: Colors.red),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true,
                            fillColor: Color(0xFFD9D9D9))),
                  ),
                  // items: tokenList,
                  dropdownButtonProps: const DropdownButtonProps(
                      icon: FaIcon(FontAwesomeIcons.chevronDown), iconSize: 15),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    textAlignVertical: TextAlignVertical(y: 0.0),
                    dropdownSearchDecoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: "Token",
                      filled: true,
                      fillColor: Color(0xFF1D3557),
                      focusColor: Colors.transparent,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  onChanged: print,
                  // selectedItem: "Algo",
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _customPopupItemBuilder(
      BuildContext context, TokenList? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
        subtitle: Text(item?.assetId?.toString() ?? ''),
        leading: CircleAvatar(
          backgroundColor: Color(0xFF95EAC8),
          backgroundImage: AssetImage(item?.icon ?? ''),
          child: Text(item?.name.substring(0, 1) ?? ''),
        ),
      ),
    );
  }

  Future<List<TokenList>> getData(filter) async {
    var response = await Dio().get("https://asa-list.tinyman.org/assets.json");

    final data = response.data;
    if (data != null) {
      return TokenList.fromJsonList(data);
    }

    return [];
  }
}
