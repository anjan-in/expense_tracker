import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class SetIncomeScreen extends StatefulWidget {
  const SetIncomeScreen({super.key});

  @override
  State<SetIncomeScreen> createState() => _SetIncomeScreenState();
}

class _SetIncomeScreenState extends State<SetIncomeScreen> {
  final TextEditingController _incomeController = TextEditingController();
  final Box<MonthlyIncome> _incomeBox = Hive.box<MonthlyIncome>(
    'monthlyIncomeBox',
  );
  late String _currentMonthKey;

  @override
  void initState() {
    super.initState();
    _currentMonthKey = DateFormat('yyyy-MM').format(DateTime.now());
    _loadCurrentMonthIncome();
  }

  void _loadCurrentMonthIncome() {
    final existing = _incomeBox.get(_currentMonthKey);
    if (existing != null) {
      _incomeController.text = existing.income.toString();
    }
  }

  void _saveIncome() {
    final input = double.tryParse(_incomeController.text);
    if (input == null || input < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid income amount')),
      );
      return;
    }

    final newIncome = MonthlyIncome(month: _currentMonthKey, income: input);
    _incomeBox.put(_currentMonthKey, newIncome);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Income saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Monthly Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'For $_currentMonthKey',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Income',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIncome,
              child: const Text('Save Income'),
            ),
          ],
        ),
      ),
    );
  }
}
