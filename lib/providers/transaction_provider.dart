import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    _transactions = TransactionService.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await TransactionService.addTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await TransactionService.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await TransactionService.deleteTransaction(id);
    await loadTransactions();
  }
}
