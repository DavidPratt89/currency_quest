import 'package:flutter/material.dart';
import '../widgets/bank.dart';

class WoolongPage extends StatelessWidget {
  const WoolongPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);
    const exchangeRate = 0.007;
    final purchaseOptions = [
      {
        'item': 'Bell Peppers and Beef with Mushrooms',
        'amount': 1066.17,
        'image': 'assets/bell_peppers_beef.jpg',
      },
      {
        'item': 'Lucky Strikes',
        'amount': 1549.50,
        'image': 'assets/lucky_strikes.jpg',
      },
      {
        'item': 'Pay off Faye\'s Debt',
        'amount': 300028000,
        'image': 'assets/ein_food.jpg',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/woolong.png',
              fit: BoxFit.scaleDown,
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
                      color: Colors.black,
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
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 150),
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
              'Do you want to buy $item for \u20A9${formatNumber(amount)}?'),
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
