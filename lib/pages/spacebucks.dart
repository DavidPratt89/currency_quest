import 'package:flutter/material.dart';
import '../widgets/bank.dart';

class SpacebucksPage extends StatelessWidget {
  const SpacebucksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);
    const exchangeRate = 2.5;
    final purchaseOptions = [
      {
        'item': 'Raspberry Jam',
        'amount': 8.99,
        'image': 'assets/raspberry_jam.jpg',
      },
      {
        'item': 'Spaceballs Coloring Book',
        'amount': 14.99,
        'image': 'assets/spaceballs_coloring_book.jpg',
      },
      {
        'item': 'Spaceballs Lunchbox',
        'amount': 20.99,
        'image': 'assets/spaceballs_lunchbox.jpg',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/spacebucks.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Balance\nUSD: \$${formatNumber(bank.vault.balance)}',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 17, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Spacebucks: ${formatNumber(bank.vault.balance / exchangeRate)}',
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 17, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
                            backgroundColor:
                                Color.fromARGB(255, 255, 17, 0), // Gold color
                            foregroundColor: Colors.white,
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
                              Flexible(
                                child: Text(
                                  option['item'] as String,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
