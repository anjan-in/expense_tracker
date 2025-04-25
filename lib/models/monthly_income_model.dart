import 'package:hive/hive.dart';

part 'monthly_income_model.g.dart';

@HiveType(typeId: 1)
class MonthlyIncome extends HiveObject {
  @HiveField(0)
  final String month; // Format: 'yyyy-MM'

  @HiveField(1)
  final double income;

  MonthlyIncome({required this.month, required this.income});
}
