import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_model.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:algorand_dart/algorand_dart.dart';
import '../../helper.dart';

import '../utils/app_layout.dart';
import '../utils/token_list.dart';

class SwapWidget extends StatefulWidget {
  final String swap;
  final Function fetchQuote;
  final Function cancelTimer;

  const SwapWidget(
      {super.key,
      required this.swap,
      required this.fetchQuote,
      required this.cancelTimer});

  @override
  State<SwapWidget> createState() =>
      _SwapWidgetState(fetchQuote: fetchQuote, cancelTimer: cancelTimer);
}

class _SwapWidgetState extends State<SwapWidget> {
  final Function fetchQuote;
  final Function cancelTimer;
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _SwapWidgetState({required this.fetchQuote, required this.cancelTimer});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      if (widget.swap == "from") {
        myController.text = model.swapInputAmt?.toString() ?? '';
      } else if (widget.swap == "to") {
        myController.text = model.swapOutputAmt?.toString() ?? '';
      }

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
                        ? TextField(
                            controller: myController,
                            onChanged: (value) => cancelTimer(),
                            onSubmitted: (value) => fetchQuote(value, true),
                            enabled: true,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration.collapsed(
                              hintText: "0.00",
                            ),
                          )
                        : TextField(
                            controller: myController,
                            onChanged: (value) => cancelTimer(),
                            onSubmitted: (value) => fetchQuote(value, false),
                            enabled: true,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration.collapsed(
                              hintText: "0.00",
                            ))),
                Container(
                  width: 120,
                  height: 35,
                  child: DropdownSearch<Asset>(
                    items: model.assetList.entries.map((e) => e.value).toList(),
                    // asyncItems: (filter) => getData(filter),
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
                    onChanged: (newValue) =>
                        Provider.of<AppModel>(context, listen: false)
                            .setInputOutputAsset(
                                widget.swap == "from" ? true : false,
                                newValue?.index ?? 0),
                    selectedItem: model.assetList[widget.swap == "from"
                        ? model.inputAssetID
                        : model.outputAssetID],
                    dropdownBuilder: customDD,
                    // dropdownButtonProps: const DropdownButtonProps(
                    //     icon: FaIcon(FontAwesomeIcons.chevronDown),
                    //     iconSize: 15),
                    // itemAsString: (item) => item.params.unitName ?? '',
                    // dropdownDecoratorProps: const DropDownDecoratorProps(
                    //   textAlignVertical: TextAlignVertical(y: 0.0),
                    //   dropdownSearchDecoration: InputDecoration(
                    //     isCollapsed: true,
                    //     contentPadding: EdgeInsets.only(left: 15),
                    //     hintText: "Token",
                    //     filled: true,
                    //     fillColor: Color(0xFF1D3557),
                    //     focusColor: Colors.transparent,
                    //     border: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.transparent,
                    //           width: 0,
                    //         ),
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(20))),
                    //   ),
                    // ),
                    // onChanged: print,
                    // selectedItem: "Algo",
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
    });
  }

  Widget customDD(BuildContext context, Asset? selectedItem) {
    // if (selectedItem == null) {
    //   return ListTile(
    //     contentPadding: EdgeInsets.all(0),
    //     leading: CircleAvatar(),
    //     title: Text("No item selected"),
    //   );
    // }

    return Row(children: [
      SizedBox(
          width: 20,
          child: getASAiconWidget(
              Provider.of<AppModel>(context, listen: false).asaIconList,
              widget.swap == "from"
                  ? Provider.of<AppModel>(context, listen: false).inputAssetID
                  : Provider.of<AppModel>(context, listen: false)
                      .outputAssetID)),
      const SizedBox(width: 5),
      Text(selectedItem?.params.unitName ?? '')
    ]);
  }

  Widget _customPopupItemBuilder(
      BuildContext context, Asset item, bool isSelected) {
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
        title: Text(item.params.name ?? ''),
        subtitle: Text(item.index.toString()),
        leading: CircleAvatar(
          backgroundColor: Color(0xFF95EAC8),
          // backgroundImage: ,
          child: getASAiconWidget(
              Provider.of<AppModel>(context, listen: false).asaIconList,
              item.index),
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
