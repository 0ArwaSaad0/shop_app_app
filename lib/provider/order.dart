import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopappapp/widget/cart_item.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  final String userId;
  List<OrderItem> _orders = [];
final String authToken;
Order(this.authToken,this.userId,this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-update-2719f.firebaseio.com/$userId.json?auth=$authToken';
    final response = await http.get(url);
    //  print(json.decode(response.body));
    final List<OrderItem> loadOrders = [];
    final extractedDate = json.decode(response.body) as Map<String, dynamic>;
    if(extractedDate==null){
      return;
    }
    extractedDate.forEach((orderId, orderDate) {
      loadOrders.add(OrderItem(
        id: orderId,
        amount: orderDate['amount'],
        dateTime: DateTime.parse(orderDate['dateTime']),
        products: (orderDate['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ))
            .toList(),
      ));
    });
    _orders=loadOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-update-2719f.firebaseio.com/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
