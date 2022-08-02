import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_acc/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Orders"),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // error handling stuff here
                return const Center(
                  child: Text("An error has occurred!"),
                );
              } else {
                return Consumer<Orders>(builder: (context, orderData, child) {
                  return ListView.builder(
                    itemBuilder: ((context, index) => OrderItem(
                          orderData.orders[index],
                        )),
                    itemCount: orderData.orders.length,
                  );
                });
              }
            }
          },
        ));
  }
}
