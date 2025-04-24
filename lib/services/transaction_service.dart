import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static const String _boxName = 'transactions';

  /// Open Hive box (ideally once in main.dart before UI)
  static Future<Box<TransactionModel>> _openBox() async {
    return await Hive.openBox<TransactionModel>(_boxName);
  }

  /// Add a new transaction
  static Future<void> addTransaction(TransactionModel transaction) async {
    final box = await _openBox();
    await box.add(transaction);
  }

  /// Get all transactions, sorted by date descending
  static Future<List<TransactionModel>> getAllTransactions() async {
    final box = await _openBox();
    final transactions = box.values.toList();
    transactions.sort((a, b) => b.date.compareTo(a.date)); // recent first
    return transactions;
  }

  /// Delete transaction by key
  static Future<void> deleteTransaction(String id) async {
    // final box = await _openBox();
    final box = Hive.box<TransactionModel>('transactions');
    await box.delete(id);
  }

  /// Update transaction by key
  static Future<void> updateTransaction(
    // int key,
    TransactionModel updatedTxn,
  ) async {
    // final box = await _openBox();
    // await box.put(key, updated);
    final box = Hive.box<TransactionModel>('transactions');
    await box.put(updatedTxn.id, updatedTxn);
  }

  /// Optional: Clear all (for reset/debug)
  static Future<void> clearAllTransactions() async {
    final box = await _openBox();
    await box.clear();
  }
}
