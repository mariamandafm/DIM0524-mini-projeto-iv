import 'package:f08_eshop_app/model/cart.dart';
import 'package:flutter/material.dart';

class OrderDatailPage extends StatelessWidget {
  const OrderDatailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Order order =
        ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
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
                        'R\$ ${order.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    title: Text(order.items[i].title),
                    subtitle: Text('R\$ ${order.items[i].price}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}