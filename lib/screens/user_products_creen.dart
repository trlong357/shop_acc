import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your products"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return RefreshIndicator(
                  onRefresh: () => _refreshProduct(context),
                  child: Consumer<Products>(
                    builder: (context, productsData, _) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) => Column(
                                children: [
                                  UserProductItem(
                                    productsData.items[index].id,
                                    productsData.items[index].title,
                                    productsData.items[index].imageUrl,
                                  ),
                                  const Divider(),
                                ],
                              )),
                    ),
                  ));
            }
          },
        ));
  }
}
