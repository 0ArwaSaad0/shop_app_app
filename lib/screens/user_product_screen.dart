import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopappapp/provider/product_provider.dart';
import 'package:shopappapp/screens/edit_product.dart';
import 'package:shopappapp/widget/app_drawer.dart';
import 'package:shopappapp/widget/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  Future<void> refreshProducts(BuildContext context) async {
  await  Provider.of<ProductProvider>(context,listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
   // final productDate = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
future: refreshProducts(context),
        builder:(ctx,snapShot)=> snapShot.connectionState==ConnectionState.waiting?Center(
          child: CircularProgressIndicator(),
        )
              :RefreshIndicator(
          onRefresh: ()=>refreshProducts(context),
          child: Consumer<ProductProvider>(
          builder:(ctx, productDate,_) =>Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productDate.items.length,
                itemBuilder: (_, i) => Column(
                  children: <Widget>[
                    UserProductItem(
                      imageUrl: productDate.items[i].imageUrl,
                      title: productDate.items[i].title,
                      id: productDate.items[i].id,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
