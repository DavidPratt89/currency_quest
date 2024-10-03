import 'package:flutter/material.dart';
import 'package:currency_quest/widgets/bank.dart';

class GoldCoinsPage extends StatelessWidget {
  const GoldCoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);
    const exchangeRate = 0.0004; // Actual Gold Exchange Rate

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
                          'Horadric Cube',
                          1.88,
                          exchangeRate,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/cube.ico', // Path to your item image
                            fit: BoxFit.fitHeight,
                            height: 60, // Adjust the height as needed
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Horadric Cube\n(1.88 USD)',
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
                          'Rejuvenation Potion',
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
                            'Rejuvenation Potion\n(1,549.50 USD)',
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
                          'Faye Valentine\'s Debt',
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
                            'Pay off Faye\'s Debt\n(300,028,000 USD)',
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
