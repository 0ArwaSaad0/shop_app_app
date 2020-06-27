import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopappapp/provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  /*final String title;
  final String price;
  ProductDetailScreen({this.title, this.price});*/

  static const routName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final prductId = ModalRoute.of(context).settings.arguments as String;
    final loadProduct = Provider.of<ProductProvider>(context, listen: false)
        .finedById(prductId);
    return Scaffold(
      /* appBar: AppBar(
        title: Text(loadProduct.title),
      ),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadProduct.title,style: TextStyle(color: Colors.red),textAlign: TextAlign.end,),
              background: Hero(
                  tag: loadProduct.id,
                  child: Image.network(
                    loadProduct.imageUrl,
                    fit: BoxFit.cover,
                  )
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadProduct.price}',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 300,
                width: double.infinity,
            ),
              SizedBox(height: 800,)
            ]),
          ),
        ],
        /*

        ),*/
      ),
    );
  }
}
