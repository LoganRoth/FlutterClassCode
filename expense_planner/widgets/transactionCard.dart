import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_planner/models/transactions.dart';

class TransactionCard extends StatelessWidget {
  final Transaction tx;
  final Function removeFunc;

  TransactionCard(this.tx, this.removeFunc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FittedBox(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  '\$${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tx.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().format(tx.date),
                    style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            Center(
              child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => removeFunc(tx),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
