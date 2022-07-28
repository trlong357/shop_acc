import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen(
      // this.title,
      // this.price,
      {
    Key? key,
  }) : super(key: key);

  // final double price;
  // final String title;

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
