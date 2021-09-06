import 'package:expense_planner/widgets/transactionTile.dart';
import 'package:flutter/material.dart';

import 'package:expense_planner/models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function removeFunc;
  final Function editFunc;

  TransactionList(this.transactions, this.removeFunc, this.editFunc);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Text(
                    'No Transactions Yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return TransactionTile(transactions[index], removeFunc, editFunc);
              },
              itemCount: transactions.length,
            ),
    );
  }
}
