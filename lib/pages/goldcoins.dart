import 'package:flutter/material.dart';
import 'package:currency_quest/widgets/bank.dart';

class GoldCoinsPage extends StatelessWidget {
  const GoldCoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);
    const exchangeRate = 0.0004; // Actual Gold Exchange Rate
    final purchaseOptions = [
      {
        'item': 'Horadric Cube',
        'amount': 1.88,
        'image': 'assets/cube.ico',
      },
      {
        'item': 'Rejuvenation Potion',
        'amount': 1549.50,
        'image': 'assets/lucky_strikes.jpg',
      },
      {
        'item': 'Faye Valentine\'s Debt',
        'amount': 300028000,
        'image': 'assets/ein_food.jpg',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/diablo_gold.jpg',
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
                    'Balance\nUSD: \$${formatNumber(bank.vault.balance)}',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Gold Coins: ${formatNumber(bank.vault.balance / exchangeRate)}',
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 300),
                  Expanded(
                    child: ListView.builder(
                      itemCount: purchaseOptions.length,
                      itemBuilder: (context, index) {
                        final option = purchaseOptions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                showPurchaseDialog(
                                  context,
                                  bank,
                                  option['item'] as String,
                                  option['amount'] as double,
                                  exchangeRate,
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    option['image'] as String,
                                    fit: BoxFit.fitHeight,
                                    height: 60,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    option['item'] as String,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
              'Do you want to buy $item for \$${(amount).toStringAsFixed(2)}?'),
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
