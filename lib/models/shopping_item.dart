class ShoppingItem {
  String articleCode;
  String shopCode;
  DateTime availableFrom;
  DateTime availableUntil;
  double eatOutPrice;
  double eatInPrice;
  String articleName;
  List dayParts;
  String internalDescription;
  String customerDescription;
  String imageUri;
  String thumbnailUri;

  ShoppingItem({
    required this.articleCode,
    required this.shopCode,
    required this.availableFrom,
    required this.availableUntil,
    required this.eatOutPrice,
    required this.eatInPrice,
    required this.articleName,
    required this.dayParts,
    required this.internalDescription,
    required this.customerDescription,
    required this.imageUri,
    required this.thumbnailUri,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      articleCode: json['articleCode'] as String,
      shopCode: json['shopCode'] as String,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableUntil: DateTime.parse(json['availableUntil'] as String),
      eatOutPrice: json['eatOutPrice'] as double,
      eatInPrice: json['eatInPrice'] as double,
      articleName: json['articleName'] as String,
      dayParts: json['dayParts'] as List,
      internalDescription: json['internalDescription'] as String,
      customerDescription: json['customerDescription'] as String,
      imageUri: json['imageUri'] as String,
      thumbnailUri: json['thumbnailUri'] as String,
    );
  }
}
