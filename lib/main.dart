import 'package:flutter/material.dart';
import 'package:shop_acc/screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tony\'s shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
      },
    );
  }
}
