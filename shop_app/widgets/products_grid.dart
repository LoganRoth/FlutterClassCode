import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final prodData = Provider.of<ProductsProvider>(context);
    final prods =  showFavs ? prodData.favItems : prodData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: prods[i],
        child: ProductItem(
          // id: prods[i].id,
          // title: prods[i].title,
          // imageUrl: prods[i].imageUrl,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      itemCount: prods.length,
    );
  }
}
