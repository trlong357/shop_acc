import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_acc/screens/order_screen.dart';
import '../screens/user_products_creen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          // const Divider(),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Manage Products'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logOut();
              },
            ),
          ))
        ],
      ),
    );
  }
}
