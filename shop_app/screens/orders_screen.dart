import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/orders.dart' show Orders;
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;

  /*@override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async { // this is a little hack FYI
    //setState(() {
    _isLoading = true;
    //});
    /*await*/
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    //});
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              // Do error handling
              return Center(
                child: Text('An Error Occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
      // Note: must not set up order data listen, instead need a Consumer
      // Allows you to make this a stateless widget

      /* body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
              itemCount: orderData.orders.length,
            ), */
    );
  }
}
