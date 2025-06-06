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

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
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
}
