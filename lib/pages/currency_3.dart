//****************************************************************************
// currency_1.dart - Implements a fictional currency page
//
// Boise State University CS 402
// Dr. Henderson
// Homework 4
//
// This implements the fictional currency UI as described in the README.md.
// You will need to copy this module three times and implement three different
// fictional currencies
//----------------------------------------------------------------------------
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/bank.dart';

// TODO: Create a page to implement the fictional currency UI. (50 pts)
// Override the build method to display the UI as specified in the README.md
// You will need to get an instance of the bank using Bank.of(context)
// Once you have the bank instance you can call Bank.buy() with your fictional items and you can get the current balance through the Bank.vault.balance getter
// You will need to convert the balance based on the exchange rate (you make up)
class Currency3Page extends StatelessWidget {
  const Currency3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);
    final exchangeRate = 2.5; // Example exchange rate: 1 USD = 2.5 Currency 3

    void showConfirmationDialog(String item, double amount) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Purchase'),
            content: Text(
                'Do you want to buy $item for ${amount.toStringAsFixed(2)} Currency 3?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  if (bank.buy(item, amount)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Purchased $item')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Insufficient balance')),
                    );
                  }
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Currency 3'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Balance in USD: \$${bank.vault.balance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Balance in Currency 3: ${(bank.vault.balance * exchangeRate).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog('Item 7', 15 / exchangeRate);
              },
              child: Text('Buy Item 7 (15 Currency 3)'),
            ),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog('Item 8', 25 / exchangeRate);
              },
              child: Text('Buy Item 8 (25 Currency 3)'),
            ),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog('Item 9', 35 / exchangeRate);
              },
              child: Text('Buy Item 9 (35 Currency 3)'),
            ),
          ],
        ),
      ),
    );
  }
}

// Total points: 50
