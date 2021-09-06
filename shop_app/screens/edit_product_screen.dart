import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    title: '',
    price: 0,
    desc: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': '0',
    'desc': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _edittedProduct =
            Provider.of<ProductsProvider>(context).findById(prodId);
        _initValues = {
          'title': _edittedProduct.title,
          'price': _edittedProduct.price.toString(),
          'desc': _edittedProduct.desc,
          //'imageUrl': _edittedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _edittedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_edittedProduct.id != null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_edittedProduct.id, _edittedProduct);
      } else {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_edittedProduct);
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error Occured'),
              content: Text(error.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _edittedProduct = Product(
                              title: value,
                              id: _edittedProduct.id,
                              desc: _edittedProduct.desc,
                              imageUrl: _edittedProduct.imageUrl,
                              price: _edittedProduct.price,
                              isFav: _edittedProduct.isFav);
                        },
                        validator: (value) {
                          var text;
                          if (value.isEmpty) {
                            text = 'Please provide a title.';
                          } else {
                            text = null;
                          }
                          return text;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (value) {
                          _edittedProduct = Product(
                              title: _edittedProduct.title,
                              id: _edittedProduct.id,
                              desc: _edittedProduct.desc,
                              imageUrl: _edittedProduct.imageUrl,
                              price: double.parse(value),
                              isFav: _edittedProduct.isFav);
                        },
                        validator: (value) {
                          var text;
                          if (value.isEmpty) {
                            text = 'Please provide a price.';
                          } else {
                            if (double.tryParse(value) == null) {
                              text = 'Please enter a valid number.';
                            } else if (double.parse(value) <= 0) {
                              text = 'Please enter a number greater than 0.';
                            } else {
                              text = null;
                            }
                          }
                          return text;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['desc'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        onSaved: (value) {
                          _edittedProduct = Product(
                              title: _edittedProduct.title,
                              id: _edittedProduct.id,
                              desc: value,
                              imageUrl: _edittedProduct.imageUrl,
                              price: _edittedProduct.price,
                              isFav: _edittedProduct.isFav);
                        },
                        validator: (value) {
                          var text;
                          if (value.isEmpty) {
                            text = 'Please provide a description.';
                          } else if (value.length < 10) {
                            text = 'Desc needs to be at least 10 characters.';
                          } else {
                            text = null;
                          }
                          return text;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
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
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller:
                                  _imageUrlController, // Need to have BEFORE form submitted
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _edittedProduct = Product(
                                    title: _edittedProduct.title,
                                    id: _edittedProduct.id,
                                    desc: _edittedProduct.desc,
                                    imageUrl: value,
                                    price: _edittedProduct.price,
                                    isFav: _edittedProduct.isFav);
                              },
                              validator: (value) {
                                var text;
                                if (value.isEmpty) {
                                  text = 'Please provide an Image URL.';
                                } else if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  text = 'Please provide a valid URL.';
                                } else if (!value.endsWith('png') &&
                                    !value.endsWith('jpg') &&
                                    !value.endsWith('jpeg')) {
                                  text = 'Please provide a valid URL.';
                                } else {
                                  text = null;
                                }
                                return text;
                              },
                            ),
                          ),
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
