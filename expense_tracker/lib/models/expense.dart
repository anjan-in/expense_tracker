import 'package:hive/hive.dart';

part 'expense.g.dart'; // This line tells Flutter to generate a file.

@HiveType(typeId: 0)
enum Category { food, travel, shopping, bills, others }

class Expense {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}
