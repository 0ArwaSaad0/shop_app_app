import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopappapp/provider/product_provider.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext ctx) {
    final productsData = Provider.of<ProductProvider>(ctx);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
       value: products[i],
        child: ProductItem(
        /*  id: products[i].id,
          title: products[i].title,
          imageUrl: products[i].imageUrl,*/
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
