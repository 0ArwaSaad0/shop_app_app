import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopappapp/provider/cart.dart';
import 'package:shopappapp/provider/product.dart';
import 'package:shopappapp/provider/product_provider.dart';
import 'package:shopappapp/screens/cart_screen.dart';
import 'package:shopappapp/widget/app_drawer.dart';
import 'package:shopappapp/widget/padge.dart';
import 'package:shopappapp/widget/product_grid.dart';
import 'package:provider/provider.dart';

enum filtersOption {
  Favorite,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool _showOnlyFavorites = false;
  bool isInitState = true;
  bool isLoading = false;

  @override
  void initState() {
    /* Future.delayed(Duration.zero).then((_) {
      Provider.of<ProductProvider>(context).fetchAndSetProducts();
    });*/
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInitState) {
      setState(() {
        isLoading = true;
      });

      Provider.of<ProductProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInitState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productDate = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (filtersOption selectedVale) {
                if (selectedVale == filtersOption.Favorite) {
                  productDate.showFavoriteOnly();
                } else {
                  productDate.showAll();
                }
              },
              child: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: filtersOption.Favorite,
                    ),
                    PopupMenuItem(
                        child: Text('Show All'), value: filtersOption.All),
                  ]),
          Consumer<Cart>(
            builder: (_, cartDate, ch) => Badge(
              child: ch,
              value: cartDate.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
