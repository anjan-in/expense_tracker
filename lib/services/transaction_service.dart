import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static final Box<TransactionModel> _box = Hive.box<TransactionModel>(
    'transactions',
  );

  static Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  static Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  static List<TransactionModel> getTransactions() {
    return _box.values.toList();
  }

  // static Box<TransactionModel> getBox() {
  //   return Hive.box<TransactionModel>(HiveBoxes.transactions);
  // }

  // static Future<void> addTransaction(TransactionModel transaction) async {
  //   try {
  //     final box = getBox();
  //     await box.put(transaction.id, transaction);
  //   } catch (e) {
  //     throw Exception('Failed to add transaction.');
  //   }
  // }

  // static Future<List<TransactionModel>> getAllTransactions() async {
  //   try {
  //     final box = getBox();
  //     final transactions = box.values.toList();
  //     transactions.sort((a, b) => b.date.compareTo(a.date));
  //     return transactions;
  //   } catch (e) {
  //     throw Exception('Failed to load transactions.');
  //   }
  // }

  // static Future<void> deleteTransaction(String id) async {
  //   try {
  //     final box = getBox();
  //     await box.delete(id);
  //   } catch (e) {
  //     throw Exception('Failed to delete transaction.');
  //   }
  // }

  // static Future<void> updateTransaction(TransactionModel transaction) async {
  //   try {
  //     final box = getBox();
  //     await box.put(transaction.id, transaction);
  //   } catch (e) {
  //     throw Exception('Failed to update transaction.');
  //   }
  // }

  // static Future<void> clearAllTransactions() async {
  //   try {
  //     final box = getBox();
  //     await box.clear();
  //   } catch (e) {
  //     throw Exception('Failed to clear transactions.');
  //   }
  // }
}
