import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shopappapp/widget/cart_item.dart';


class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({ String productId,
      double price,
      String title,})
  {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId].quantity>1){
      _items.update(productId, (execistingCartItem)=>CartItem(
        id: execistingCartItem.id,
        price: execistingCartItem.price,
        title: execistingCartItem.title,
        quantity: execistingCartItem.quantity-1,
      ),);
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
  void clear(){
    _items={};
    notifyListeners();
  }
}

