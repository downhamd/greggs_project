import 'package:flutter/material.dart';
import 'package:greggs_prject/models/shopping_item.dart';

class GlobalProvider extends ChangeNotifier {
  final List<ShoppingItem> _cartItems = [];

  List<ShoppingItem> get cartItems => _cartItems;

  addToCart(ShoppingItem item) {
    _cartItems.add(item);
    notifyListeners();
  }
}
