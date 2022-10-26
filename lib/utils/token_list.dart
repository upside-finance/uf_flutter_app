class TokenList {
  final dynamic name;
  final dynamic assetId;
  final dynamic icon;

  TokenList({required this.name, this.assetId, required this.icon});

  factory TokenList.fromJson(Map<String, dynamic> json) {
    return TokenList(
        name: Map.castFrom(json["id"]["name"]),
        assetId: Map.castFrom(json["id"]["name"]),
        icon: Map.castFrom(json["id"]["name"]));
  }

  static List<TokenList> fromJsonList(List list) {
    return list.map((item) => TokenList.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByAssetId(String filter) {
    return this.assetId?.toString().contains(filter) ?? false;
  }

  ///custom comparing function to check if two users are equal
  // bool isEqual(TokenList model) {
  //   return this.name == model.name;
  // }

  @override
  String toString() => name;
}
