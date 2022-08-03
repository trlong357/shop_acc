import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl, {
    Key? key,
  }) : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Are you sure ?"),
                  content: const Text("Do you want to remove this item ?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigator.pop();
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                        onPressed: () async {
                          try {
                            await Provider.of<Products>(context, listen: false)
                                .deleteProduct(id)
                                .then((_) {
                              navigator.pop();
                            }).catchError((error) {
                              navigator.pop();
                            });
                          } catch (err) {
                            scaffold.showSnackBar(
                                const SnackBar(content: Text("Deleting fail")));
                          }
                        },
                        child: const Text("Yes"))
                  ],
                ),
              ),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
