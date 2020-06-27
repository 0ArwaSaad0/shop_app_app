import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopappapp/provider/order.dart' show Order, Orders;
import 'package:shopappapp/widget/app_drawer.dart';
import 'package:shopappapp/widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  
  @override
  Widget build(BuildContext context) {
   // final orderDate = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body:  FutureBuilder(future: Provider.of<Order>(context,listen: false).fetchAndSetOrders(),builder: (context,dateSnapshot){
        if(dateSnapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }else{
          if(dateSnapshot.error!=null){
            return Center(child: Text('An Error Ocured! '),);

          }else{
           return Consumer<Order>(builder:(context,orderDate,child)=> ListView.builder(
                itemCount: orderDate.orders.length,
                itemBuilder: (_, i) => OrderItem(orderDate.orders[i]),
           ) );}

        }
  } ),
    );
  }
}

