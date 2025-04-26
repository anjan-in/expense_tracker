import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';
import '../models/transaction_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapters();

    await _openBoxes();
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(ExpenseCategoryAdapter().typeId)) {
      Hive.registerAdapter(ExpenseCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(MonthlyIncomeAdapter().typeId)) {
      Hive.registerAdapter(MonthlyIncomeAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<TransactionModel>(HiveBoxes.transactions);
    await Hive.openBox<MonthlyIncome>(HiveBoxes.monthlyIncomeBox);
  }
}
