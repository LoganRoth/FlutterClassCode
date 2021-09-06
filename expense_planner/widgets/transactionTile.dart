import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_planner/models/transactions.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  final Function removeFunc;
  final Function editFunc;

  TransactionTile(this.tx, this.removeFunc, this.editFunc);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(child: Text('\$${tx.amount.toStringAsFixed(2)}')),
          ),
        ),
        title: Text(
          tx.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(tx.date),
        ),
        onTap: () => editFunc(context, tx),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
                label: Text('Delete'),
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                textColor: Theme.of(context).buttonColor,
                onPressed: () => removeFunc(tx),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => removeFunc(tx),
              ),
      ),
    );
  }
}
