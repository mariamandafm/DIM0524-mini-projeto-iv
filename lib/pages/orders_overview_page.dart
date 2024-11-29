import 'package:f08_eshop_app/model/cart.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersOverviewPage extends StatefulWidget {
  const OrdersOverviewPage({super.key});

  @override
  State<OrdersOverviewPage> createState() => _OrdersOverviewPageState();
}

class _OrdersOverviewPageState extends State<OrdersOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    late Future<List<Order>> user_orders = cart.fetchUserOrders();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<Order>>(
          future: user_orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vixe... algum erro aconteceu ao acessar os pedidos!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              List<Order> orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  child: ListTile(
                    title: Text('R\$ ${orders[i].totalAmount}'),
                    subtitle: Text(orders[i].dateTime.toString()),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.ORDER_DETAIL,
                      arguments: orders[i],
                    );
                  },
                ),
              );
            } else {
              return Text("Nenhum pedido cadastrado!",);
            }
          },
        ),
      ),
    );
  }
}