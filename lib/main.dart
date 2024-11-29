
import 'package:f08_eshop_app/model/cart.dart';
import 'package:f08_eshop_app/pages/cart_page.dart';
import 'package:f08_eshop_app/pages/login_page.dart';
import 'package:f08_eshop_app/pages/order_datails.dart';
import 'package:f08_eshop_app/pages/orders_overview_page.dart';
import 'package:f08_eshop_app/pages/product_detail_page.dart';
import 'package:f08_eshop_app/pages/product_form_page.dart';
import 'package:f08_eshop_app/pages/products_overview_page.dart';
import 'package:f08_eshop_app/pages/register_page.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/product_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductList()),
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ThemeData().copyWith().colorScheme.copyWith(
                primary: Colors.pink, secondary: Colors.orangeAccent)),
        home: LoginPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.PRODUCT_FORM: (context) => const ProductFormPage(),
          AppRoutes.CART: (context) => CartPage(),
          AppRoutes.LOGIN: (context) => LoginPage(),
          AppRoutes.PRODUCTS_OVERVIEW: (context) => ProductsOverviewPage(),
          AppRoutes.REGISTER: (context) => RegisterPage(),
          AppRoutes.ORDERS: (context) => const OrdersOverviewPage(),
          AppRoutes.ORDER_DETAIL: (context) => const OrderDatailPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
