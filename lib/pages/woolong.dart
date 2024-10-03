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
// ignore_for_file: unnecessary_import, unused_import

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/bank.dart';

class WoolongPage extends StatelessWidget {
  const WoolongPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);
    const exchangeRate = 0.007; // Actual Yen Exchange Rate

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/woolong.jpg', // Path to your background image
              fit: BoxFit.fitWidth,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Balance\n' 'USD: \$${formatNumber(bank.vault.balance)}',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '\u20A9'
                    ': ${formatNumber(bank.vault.balance / exchangeRate)}',
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 150),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        showPurchaseDialog(
                          context,
                          bank,
                          'Bell Peppers and Beef with Mushrooms',
                          1066.17,
                          exchangeRate,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/bell_peppers_beef.jpg', // Path to your item image
                            fit: BoxFit.fitHeight,
                            height: 60, // Adjust the height as needed
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Bell Peppers and Beef\nwith Mushrooms\n(\u20A9 1,066.17)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        showPurchaseDialog(
                          context,
                          bank,
                          'Lucky Strikes',
                          1549.50,
                          exchangeRate,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/lucky_strikes.jpg', // Path to your item image
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Lucky Strikes\n(\u20A9 1,549.50)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        showPurchaseDialog(
                          context,
                          bank,
                          'Pay off Faye\'s Debt',
                          300028000,
                          exchangeRate,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/ein_food.jpg', // Path to your item image
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Pay off Faye\'s Debt\n(\u20A9 300,028,000)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPurchaseDialog(BuildContext context, Bank bank, String item,
      double amount, double exchangeRate) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text(
              'Do you want to buy $item for ${formatNumber(amount / exchangeRate)}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  String formatNumber(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (Match match) => '${match[1]},',
        );
  }
}
