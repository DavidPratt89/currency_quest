//****************************************************************************
// bank.dart - A custom inherited widget to allow children access to the vault
//
// Boise State University CS 402
// Dr. Henderson
// Homework 4
//
// The Bank widget is used to give access to the app state, in particular the vault
//----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import '../models/vault.dart';

class Bank extends InheritedWidget {
  final GlobalKey appKey;
  Bank({
    super.key,
    required this.appKey,
    required this.vault,
    required super.child,
  });

  final Vault vault;

  void deposit(double amount) {
    vault.deposit(amount);
    // Calling setState() will force Flutter to update dependent child widgets
    appKey.currentState?.setState(() {});
  }

  bool buy(final String item, final double amount) {
    if (vault.buy(item, amount)) {
      // Calling setState() will force Flutter to update dependent child widgets
      appKey.currentState?.setState(() {});
      // TODO: Play a sound to indicate the purchase succeeded. (15 pts)
      return true;
    }
    // TODO: Play a sound to indicate the purchase failed. (15 pts)
    return false;
  }

  //**************************************************************************************************
  // These methods are standard boilerplate for InheritedWidget implementations which simplify
  // access for children.
  //--------------------------------------------------------------------------------------------------
  static Bank? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Bank>();
  }

  static Bank of(BuildContext context) {
    final Bank? result = maybeOf(context);
    assert(result != null, 'No Bank found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Bank oldWidget) => vault != oldWidget.vault;
}

// Total points: 30
