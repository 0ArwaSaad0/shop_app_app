import 'package:flutter/material.dart';
import 'package:shopappapp/provider/product_provider.dart';
import 'package:shopappapp/screens/edit_product.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;


  UserProductItem({this.title, this.imageUrl, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold= Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                try{
                 await Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
                }
               catch(error){
                 scaffold.showSnackBar(SnackBar(content:Text( 'Deleting field !'),));

               }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
