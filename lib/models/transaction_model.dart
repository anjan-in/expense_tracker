import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final ExpenseCategory category;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
    required this.type,
  });
}

@HiveType(typeId: 1)
enum ExpenseCategory {
  @HiveField(0)
  food,

  @HiveField(1)
  travel,

  @HiveField(2)
  shopping,

  @HiveField(3)
  entertainment,

  @HiveField(4)
  bills,

  @HiveField(5)
  health,

  @HiveField(6)
  education,

  @HiveField(7)
  other,

  @HiveField(8)
  salary,

  @HiveField(9)
  freelance,

  @HiveField(10)
  investment,
}

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 3) // New typeId for MonthlyIncome
class MonthlyIncome extends HiveObject {
  @HiveField(0)
  final String month; // Format: 'yyyy-MM'

  @HiveField(1)
  final double income;

  MonthlyIncome({required this.month, required this.income});
}
