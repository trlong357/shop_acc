import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_formKey.currentState != null) {
      _formKey.currentState?.save();
      print(_editedProduct.title);
      print(_editedProduct.price);
      print(_editedProduct.description);
      print(_editedProduct.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value!,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Enter a number > 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value!),
                      id: _editedProduct.id,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 5) {
                      return 'Should have at least 5 characters!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      description: value!,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        focusNode: _imageUrlFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a image URL.';
                          }
                          if (!value.startsWith('http') ||
                              (!value.startsWith('https'))) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('jpeg')) {
                            return 'Please enter a valid image URL';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => {_saveForm()},
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            imageUrl: value!,
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
