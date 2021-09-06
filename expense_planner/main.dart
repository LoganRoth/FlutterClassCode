import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_planner/widgets/newTransaction.dart';
import 'package:expense_planner/widgets/transactionList.dart';
import 'package:expense_planner/models/transactions.dart';
import 'package:expense_planner/widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksad',
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Quicksand',
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  int _numTx = 0;
  bool _showChart = false;
  Transaction _txUnderEdit;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _nullSetter() {
    _txUnderEdit = null;
  }

  void _addNewTransaction(String newTitle, double newAmount, String newDesc,
      DateTime selectedDate) {
    final newTx = Transaction(
      id: '${_numTx++}${selectedDate.toString()}',
      title: newTitle,
      amount: newAmount,
      description: newDesc,
      date: selectedDate,
    );
    setState(() {
      _transactions.add(newTx);
    });
    _nullSetter();
  }

  void _editOldTransaction(String newTitle, double newAmount, String newDesc,
      DateTime selectedDate) {
    Transaction newTx = Transaction(
      id: _txUnderEdit.id,
      title: newTitle,
      amount: newAmount,
      description: newDesc,
      date: selectedDate,
    );
    int index = _transactions.indexWhere((tx) => tx.id == _txUnderEdit.id);
    _transactions.removeAt(index);
    setState(() {
      _transactions.insert(index, newTx);
    });
    _nullSetter();
  }

  void _removeTransaction(Transaction tx) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == tx.id);
    });
  }

  void _editTransaction(BuildContext ctx, Transaction tx) {
    _txUnderEdit = tx;
    _startAddNewTransaction(ctx, _editOldTransaction);
  }

  void _startAddNewTransaction(BuildContext ctx, Function funcToUse) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: (_txUnderEdit == null)
              ? NewTransaction(funcToUse, _nullSetter)
              : NewTransaction(funcToUse, _nullSetter,
                  title: _txUnderEdit.title,
                  amount: _txUnderEdit.amount.toString(),
                  desc: _txUnderEdit.description,
                  date: _txUnderEdit.date),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final medQ = MediaQuery.of(context);
    final isLandscape = medQ.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () =>
                      _startAddNewTransaction(context, _addNewTransaction),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    _startAddNewTransaction(context, _addNewTransaction),
              ),
            ],
          );
    final txListWidget = Container(
      child: TransactionList(
        _transactions,
        _removeTransaction,
        _editTransaction,
      ),
      height:
          (medQ.size.height - appBar.preferredSize.height - medQ.padding.top) *
              0.7,
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                child: Chart(_recentTransactions),
                height: (medQ.size.height -
                        appBar.preferredSize.height -
                        medQ.padding.top) *
                    0.3,
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              (_showChart)
                  ? Container(
                      child: Chart(_recentTransactions),
                      height: (medQ.size.height -
                              appBar.preferredSize.height -
                              medQ.padding.top) *
                          0.7,
                    )
                  : txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () =>
                        _startAddNewTransaction(context, _addNewTransaction),
                  ),
          );
  }
}
