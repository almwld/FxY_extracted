import 'package:flutter/material.dart';
class WalletProvider extends ChangeNotifier {
  double _balance = 0.0;
  double get balance => _balance;
  void addBalance(double amount) { _balance += amount; notifyListeners(); }
  void subtractBalance(double amount) { _balance -= amount; notifyListeners(); }
}
