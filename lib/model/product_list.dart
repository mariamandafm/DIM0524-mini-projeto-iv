import 'dart:convert';
import 'dart:math';

import 'package:f08_eshop_app/data/dummy_data.dart';
import 'package:f08_eshop_app/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://dim0524-default-rtdb.firebaseio.com/';

  //https://st.depositphotos.com/1000459/2436/i/950/depositphotos_24366251-stock-photo-soccer-ball.jpg
  //https://st2.depositphotos.com/3840453/7446/i/600/depositphotos_74466141-stock-photo-laptop-on-table-on-office.jpg

  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  Future<List<Product>> fetchProducts() async {
    List<Product> products = [];
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products.json'));
      // print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> _productsJson = jsonDecode(response.body);
        _productsJson.forEach((id, product) {
          products.add(Product.fromJson(id, product));
        });
        _items = products;
        return products;
      } else {
        throw Exception("Aconteceu algum erro na requisição");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      var response = await http.post(Uri.parse('$_baseUrl/products.json'),
          body: jsonEncode(product.toJson()));

      if (response.statusCode == 200) {
        final id = jsonDecode(response.body)['name'];
        _items.add(Product(
            id: id,
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl));
        notifyListeners();
      } else {
        throw Exception("Aconteceu algum erro na requisição");
      }
    } catch (e) {
      throw e;
    }
    // print('executa em sequencia');
  }

  Future<void> updateProduct(Product product) async {
    try {
      var response = await http.patch(Uri.parse('$_baseUrl/products/${product.id}.json'),
          body: jsonEncode(product.toJson()));

      if (response.statusCode == 200) {
        final index = _items.indexWhere((p) => p.id == product.id);
        _items[index] = product;
        notifyListeners();
      } else {
        throw Exception("Aconteceu algum erro durante a requisição");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveProduct(Map<String, Object> data) {
    print(data);
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );


    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      final response =
          await http.delete(Uri.parse('$_baseUrl/products/${product.id}.json'));
          print("requisicao: $_baseUrl/products/${product.id}.json");

      if (response.statusCode == 200) {
        removeProductFromList(product);
      } else {
        throw Exception("Aconteceu algum erro durante a requisição");
      }
    } catch (e) {
      throw e;
    }
  }

  void removeProductFromList(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  Future<void> saveFavorite(Product product) async{
    final index = _items.indexWhere((p) => p.id == product.id);

    _items[index].toggleFavorite();
    notifyListeners();

    try {
      final response = await http.patch(Uri.parse('$_baseUrl/products/${product.id}.json'),
          body: jsonEncode({'isFavorite': _items[index].isFavorite}));

      if (response.statusCode != 200) {
        _items[index].toggleFavorite();
        notifyListeners();
        throw Exception("Aconteceu algum erro durante a requisição");
      }
    } catch (e) {
      _items[index].toggleFavorite();
      notifyListeners();
      throw e;
    }
  }
}
