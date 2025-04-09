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
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  String toString() {
    return 'Expense(title: $title, amount: $amount, date: $date, category: $category)';
  }
}

// Sample mock list
final List<Expense> dummyExpenses = [
  Expense(
    title: 'Dinner',
    amount: 25.99,
    date: DateTime.now().subtract(Duration(days: 1)),
    category: Category.food,
  ),
  Expense(
    title: 'Bus Ticket',
    amount: 3.50,
    date: DateTime.now().subtract(Duration(days: 2)),
    category: Category.travel,
  ),
  Expense(
    title: 'Netflix',
    amount: 15.00,
    date: DateTime.now().subtract(Duration(days: 4)),
    category: Category.others,
  ),
];
