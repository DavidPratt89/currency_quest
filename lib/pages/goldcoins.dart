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
        'amount': 4999.99,
        'image': 'assets/cube.ico',
      },
      {
        'item': 'Rejuvenation Potion',
        'amount': 99.99,
        'image': 'assets/rejuvenation.ico',
      },
      {
        'item': 'Scroll of Town Portal',
        'amount': 49.99,
        'image': 'assets/town_portal.png',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/diablo_gold.jpg',
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 475),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.black,
                        size: 50,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Gold Coins: ${formatNumber(bank.vault.balance / exchangeRate)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Purchase Options:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            final amountInGoldCoins =
                                (option['amount'] as double);
                            if (bank.vault.buy(
                                option['item'] as String, amountInGoldCoins)) {
                              bank.deposit(-amountInGoldCoins);
                            }
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${option['amount']} Gold Coins',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
          content:
              Text('Do you want to buy $item for \$${formatNumber(amount)}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (bank.buy(item, (amount * exchangeRate))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Purchased $item')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Insufficient balance')),
                  );
                }
              },
              child: const Text('(Ok)'),
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
