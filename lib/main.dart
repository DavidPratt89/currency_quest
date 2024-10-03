//****************************************************************************
// main.dart - Main app file
//
// Boise State University CS 402
// Dr. Henderson
// Homework 4
//----------------------------------------------------------------------------
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'pages/woolong.dart';
import 'pages/goldcoins.dart';
import 'pages/currency_3.dart';
import 'widgets/bank.dart';
import 'pages/home.dart';
import 'models/vault.dart';

void main() {
  // Create a GlobalKey that we can pass to child nodes so they can find the instance of the state
  runApp(MyApp(key: GlobalKey<_MyAppState>()));
}

//**************************************************************************************************
// Create a stateful widget so that we can create an instance of Vault to keep user's balance, etc.
//--------------------------------------------------------------------------------------------------
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState(key as GlobalKey<_MyAppState>);
}

class _MyAppState extends State<MyApp> {
  // Create a persistent Vault so changes to the user's balance, etc. do not disappear
  final Vault vault = Vault();

  // Keep a copy of the wrapper widget's key so children kind find this state instance
  final GlobalKey<_MyAppState> appKey;

  _MyAppState(this.appKey);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: Wrap a MaterialApp widget in the Bank inherited widget. (20 pts)
    // You will need to pass the appKey and vault to the Bank widget
    // Pass in the title, theme, and routes to the MaterialApp
    // Your routes should be a map of navigation routes from the route name (String) to a widget
    // We will wrap all routes in the MainScaffold widget to get a consistent look and feel so your
    // first route (the home route) should be: '/' => MainScaffold(title: 'Currency Quest', child: HomePage() ),
    // You will need to add your three pages as similar routes (with different names here)
    return Bank(
      appKey: appKey,
      vault: vault,
      child: MaterialApp(
        title: 'Currency Quest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.amber,
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        routes: {
          '/': (context) =>
              MainScaffold(title: 'Currency Quest', child: HomePage()),
          '/woolong': (context) =>
              MainScaffold(title: 'Woolong', child: WoolongPage()),
          '/goldcoins': (context) =>
              MainScaffold(title: 'Gold Coins', child: GoldCoinsPage()),
          '/currency3': (context) =>
              MainScaffold(title: 'Currency 3', child: Currency3Page()),
        },
      ),
    );
  }
}

//**************************************************************************************************
// MainScaffold is a custom widget to enforce the same scaffold settings for all routes
//--------------------------------------------------------------------------------------------------
class MainScaffold extends StatelessWidget {
  // TODO: Create two final fields: a Widget named child, and a String named title. (5 pts)
  final Widget child;
  final String title;

  // TODO: Create the constructor that takes required named parameters for the child and title fields. (5 pts)
  MainScaffold({required this.child, required this.title});

  // TODO: Override the build() method to return a Scaffold widget with the following properties: (30 pts)
  // An AppBar that sets your app's title and backgroundColor (usually Theme.oF(context).colorScheme.inversePrimary)
  //   Set the AppBar actions param to a list with a single IconButton that when pressed goes to the home screen
  //   using Navigator.of(context).pushReplacementNamed('/')
  // The body parameter set to this class' child field
  // A bottomNavigationBar with at least three items representing each of your fictional currency pages
  // An onTap function that uses the index to pass the correct named route to Navigator.of(context).pushReplacementNamed()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Woolong',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Gold Coins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Currency 3',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacementNamed('/woolong');
              break;
            case 1:
              Navigator.of(context).pushReplacementNamed('/goldcoins');
              break;
            case 2:
              Navigator.of(context).pushReplacementNamed('/currency3');
              break;
          }
        },
      ),
    );
  }
}
// Total points: 60