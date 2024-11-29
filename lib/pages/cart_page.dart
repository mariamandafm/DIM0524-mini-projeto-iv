import 'package:f08_eshop_app/model/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Consumer<Cart>(
          builder: (context, carrinho, child) {
            return Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            'R\$ ${carrinho?.totalAmount}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                        TextButton(
                          onPressed: () {
                            print(cart.toJson());
                            cart.checkout();
                          },
                          child: Text('COMPRAR'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: carrinho.itemCount,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                carrinho.items.values.toList()[index].title,
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(),
                              Text(
                                'R\$ ${carrinho.items.values.toList()[index].price}',
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  carrinho.decrementItem(carrinho.items.keys.toList()[index]);
                                }, 
                                icon: Icon(Icons.remove)),
                              Chip(
                                label: Text(
                                  '${carrinho.items.values.toList()[index].quantity}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  carrinho.addItem(carrinho.items.keys.toList()[index], carrinho.items.values.toList()[index].price, carrinho.items.values.toList()[index].title);
                                }, 
                                icon: Icon(Icons.add)),
                              IconButton(
                                onPressed: () {
                                  carrinho.removeItem(carrinho.items.keys.toList()[index]);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
      ),
      )
    );
  }
}