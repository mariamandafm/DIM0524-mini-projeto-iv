import 'package:f08_eshop_app/model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final String id;
  final List<Product> items;
  final double totalAmount;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
  });

factory Order.fromJson(Map<String, dynamic> json) {
  List<Product> productsList = [];

  if (json['items'] != null) {
    (json['items'] as Map<String, dynamic>).forEach((key, value) {
      productsList.add(Product(
        id: key,
        title: value['title'] ?? '',
        description: value['description'] ?? '',
        price: (value['price'] ?? 0).toDouble(), 
        imageUrl: value['imageUrl'] ?? '',
        isFavorite: value['isFavorite'] ?? false,
      ));
    });
  }

    return Order(
      id: json['id'] ?? '', 
      items: productsList,
      totalAmount:
          (json['totalAmount'] ?? 0).toDouble(), 
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ??
          DateTime.now(),
    );
  }
}


class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  final _baseUrl = 'https://dim0524-default-rtdb.firebaseio.com/';
  Map<String, CartItem> _items = {};
  User? user = FirebaseAuth.instance.currentUser;
  List<Order> orders = [];

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  List<Order> get userOrders {
    return [...orders];
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'items': _items.map((key, cartItem) {
        return MapEntry(key, {
          'id': cartItem.id,
          'title': cartItem.title,
          'price': cartItem.price,
          'quantity': cartItem.quantity
        });
      }),
      'totalAmount': totalAmount,
      'dateTime': DateTime.now().toIso8601String(),
      'userId': user!.uid,
    };
    return data;
  }

  Future<void> checkout() async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/orders.json'),
        body: jsonEncode(toJson()),
      );
      if (response.statusCode == 200) {
        _items.clear();
        notifyListeners();
      } else {
        throw Exception("Aconteceu algum erro na requisição");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Order>> fetchUserOrders() async {
    List<Order> _orders = [];
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/orders.json?orderBy="userId"&equalTo="${user!.uid}"'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> ordersJson = jsonDecode(response.body);
        print(ordersJson);
        ordersJson.forEach((id, orderData) {
          _orders.add(Order.fromJson({...orderData, 'id': id}));
        });
        return _orders;
      } else {
        throw Exception("Aconteceu algum erro na requisição");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
