import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_acc/providers/orders.dart';
import 'package:shop_acc/screens/cart_screen.dart';
import 'package:shop_acc/screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/order_screen.dart';
import 'screens/user_products_creen.dart';
import 'providers/products.dart';
import 'providers/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Tony\'s shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
        },
      ),
    );
  }
}
