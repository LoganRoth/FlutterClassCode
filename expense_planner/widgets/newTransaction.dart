import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  final Function nullSetter;
  final String title;
  final String amount;
  final String desc;
  final DateTime date;

  NewTransaction(this.addTx, this.nullSetter,
      {this.title = '', this.amount = '', this.desc = '', this.date});

  @override
  _NewTransactionState createState() =>
      _NewTransactionState(title, amount, desc, date, nullSetter);
}

class _NewTransactionState extends State<NewTransaction> {
  final String defTitle;
  final String defAmount;
  final String defDesc;
  final Function nullSetter;
  TextEditingController _titleController;
  TextEditingController _amountController;
  TextEditingController _descController;
  DateTime _selectedDate;

  _NewTransactionState(this.defTitle, this.defAmount, this.defDesc,
      this._selectedDate, this.nullSetter);

  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: this.defTitle);
    _amountController = new TextEditingController(text: this.defAmount);
    _descController = new TextEditingController(text: this.defDesc);
  }

  void dispose() {
    super.dispose();
    nullSetter();
  }

  void _submitData() {
    if (_amountController.text.isEmpty || _titleController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    String enteredDesc = _descController.text;
    if (enteredTitle.isEmpty || enteredAmount < 0 || _selectedDate == null) {
      return;
    }
    if (enteredDesc.isEmpty) {
      enteredDesc = '';
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      enteredDesc,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _percentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text((_selectedDate == null)
                          ? 'No Date Chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate).toString()}'),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text('Choose Date',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _percentDatePicker,
                          )
                        : FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Choose Date',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _percentDatePicker,
                          )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      maxLines: 10,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      controller: _descController,
                      onSubmitted: (_) => _submitData(),
                    ),
                  ),
                  Platform.isIOS
                      ? CupertinoButton(
                          child: Text(
                            'Add Transaction',
                            style: Theme.of(context).textTheme.button,
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: _submitData,
                        )
                      : RaisedButton(
                          child: Text(
                            'Add Transaction',
                            style: Theme.of(context).textTheme.button,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).textTheme.button.color,
                          onPressed: _submitData,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
