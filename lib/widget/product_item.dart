import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:shopappapp/provider/auth.dart';
import 'package:shopappapp/provider/cart.dart';
import 'package:shopappapp/provider/product.dart';
import 'package:shopappapp/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
/*  final String id;
  final String title;
  final String imageUrl;
  ProductItem(
      {@required this.imageUrl, @required this.id, @required this.title});*/
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authDate = Provider.of<Auth>(context, listen: false);
    print('Product Rebuilds');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.00),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              //   Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProductDetailScreen(title),));
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routName,
                arguments: prod.id,
              );
            },
            child: Hero(
              tag: prod.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/image/placseholder.png'),
                image: NetworkImage(prod.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: Container(
          width: MediaQuery.of(context).size.width / 30,
          height: MediaQuery.of(context).size.height / 25,
          child: GridTileBar(
            backgroundColor: Theme.of(context).accentColor,
            leading: Consumer<Product>(
                builder: (ctx, prod, child) => IconButton(
                      icon: Icon(prod.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        prod.toggleFavoriteStatus(
                            authDate.token, authDate.userId);
                      },
                    )),
            title: Text(
              prod.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(
                    productId: prod.id, price: prod.price, title: prod.title);
                prefix0.Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Added Item to aCart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.red,
                    onPressed: () {
                      cart.removeSingleItem(prod.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
