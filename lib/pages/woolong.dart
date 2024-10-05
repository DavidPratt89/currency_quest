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
        'item': 'Buy Food for Ein',
        'amount': 5949.00,
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
              alignment: Alignment.topCenter,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 375),
                  Text(
                    'Balance\nUSD: \$${formatNumber(bank.vault.balance)}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('\u20A9',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      const SizedBox(width: 10),
                      Text(
                        ' WOOLONG: ${formatNumber(bank.vault.balance / exchangeRate)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const Text(
                    'Purchase Options:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD4AF37), // Gold color
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              showPurchaseDialog(
                                context,
                                bank,
                                option['item'] as String,
                                option['amount'] as dynamic,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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
