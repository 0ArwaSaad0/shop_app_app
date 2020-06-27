import 'package:flutter/material.dart';
import 'package:shopappapp/helpers/custome_route.dart';
import 'package:shopappapp/screens/cart_screen.dart';
import 'package:shopappapp/screens/edit_product.dart';
import 'package:shopappapp/screens/order_screen.dart';
import 'package:shopappapp/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopappapp/screens/product_overview_screen.dart';
import 'package:shopappapp/provider/product_provider.dart';
import 'package:shopappapp/screens/splash_screen.dart';
import 'package:shopappapp/screens/user_product_screen.dart';

import 'provider/auth.dart';
import 'provider/cart.dart';
import 'provider/order.dart';
import 'screens/auth_Screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductProvider>(
            builder: (ctx, auth, previousProduct) => ProductProvider(
                auth.token,
                auth.userId,
                previousProduct == null ? [] : previousProduct.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            builder: (ctx, auth, previousOrder) => Order(
              auth.token,
              auth.userId,
              previousOrder == null ? [] : previousOrder.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.deepPurple,
              textTheme: ThemeData.light().textTheme.copyWith(
                  body1: TextStyle(
                    fontSize: 15,
                    color: Colors.indigoAccent,
                  ),
                  body2: TextStyle(fontSize: 20, color: Colors.black)),
              pageTransitionsTheme: PageTransitionsTheme(
                builders:{
                  TargetPlatform.android:CustomePageTransitionBuilder(),
                  TargetPlatform.iOS:CustomePageTransitionBuilder(),
                }
              ),
            ),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProduct.routeName: (ctx) => EditProduct(),
            },
          ),
        ));
  }
}
