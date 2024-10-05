//****************************************************************************
// home.dart - The home page displayed when the default route is navigated
//
// Boise State University CS 402
// Dr. Henderson
// Homework 4
//
// This widget will display the user's balance in the base currency, a button
// to make deposits, and a list of current purchased items (and their count).
//
// This widget will be displayed whenever the default '/' route is selected
//----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import '../widgets/bank.dart';

// TODO: Create a stateless widget to display the home page. (30 pts)
// In your build method, you will need to get the Bank instance by calling Bank.of(context). Once you have it
// Your widget should implement the UI as described in the README.md
// When the user presses the [deposit] button your app should call the helper method _depositDialog()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Bank.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LayoutBuilder(
              builder: (context, constraints) {
                final balanceText =
                    'Balance:\n\$${bank.vault.balance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (Match match) => '${match[1]},')}';
                final textStyle = TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                );

                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    balanceText,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _depositDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Deposit'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Inventory:',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bank.vault.items.length,
                itemBuilder: (context, index) {
                  final item = bank.vault.items.entries.elementAt(index);
                  return ListTile(
                    title: Text('${item.key}:'),
                    trailing: Text('x${item.value}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Conversion Rates:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bank.vault.conversionRates.length,
                itemBuilder: (context, index) {
                  final currency =
                      bank.vault.conversionRates.keys.elementAt(index);
                  final rate = bank.vault.conversionRates[currency];
                  return ListTile(
                    title: Text(
                      currency,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '$rate $currency = 1 USD',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Implement the helper method _depositDialog(). (100 pts)
// Take the BuildContext as a parameter named context
// Return a Future<void>
// Create a final local var called _keyForm which is set to a GlobalKey<FormState>() instance
// Call the showDialog() function with the following param values:
//   The builder parameter should be set to an anonymous function that implements the following structure:
//     return an AlertDialog with the following params:
//       title set to a Form widget with the following params:
//          key set to _keyForm
//          child set to a TextFormField that is setup to accept a decimal input and has the following params:
//              onSaved set to a function that gets the instance of the Bank and calls Bank.deposit() with the value from the form (if non-null)
//              validator set to a function that returns an error string if the amount is empty or cannot be parsed as a double, otherwise returns null
//              Note: for onSaved and validator functions consider double.tryParse() which doesn't throw an exception if parsing fails (instead returns null)
//       actions set to a list with two buttons:
//           a save button that when pressed calls _keyForm.currentState.validate() (if _keyForm.currentState is not null)
//               and if validate() returns true
//                   calls _keyForm.currentState.save() (if _keyForm.currentState is not null)
//                   calls Navigator.pop(context)
//           a cancel button that when pressed calls Navigator.pop(context)
//
Future<void> _depositDialog(BuildContext context) async {
  final _keyForm = GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('How much would you like to deposit?'),
        content: Form(
          key: _keyForm,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter an amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onSaved: (value) {
              final bank = Bank.of(context);
              final amount = double.tryParse(value ?? '');
              if (amount != null) {
                bank.deposit(amount);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_keyForm.currentState != null &&
                  _keyForm.currentState!.validate()) {
                _keyForm.currentState?.save();
                Navigator.pop(context);
              }
            },
            child: const Text('(Ok)'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
