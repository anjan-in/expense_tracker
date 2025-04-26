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
  final _formKey = GlobalKey<FormState>();
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

  // void _saveIncome() {
  //   final input = double.tryParse(_incomeController.text);
  //   if (input == null || input < 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter a valid income amount')),
  //     );
  //     return;
  //   }

  //   final newIncome = MonthlyIncome(month: _currentMonthKey, income: input);
  //   _incomeBox.put(_currentMonthKey, newIncome);

  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(const SnackBar(content: Text('Income saved successfully')));
  // }
  void _saveIncome() {
    if (_formKey.currentState!.validate()) {
      final incomeValue = double.parse(_incomeController.text.trim());

      final newIncome = MonthlyIncome(
        month: _currentMonthKey,
        income: incomeValue,
      );
      _incomeBox.put(_currentMonthKey, newIncome);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income saved successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Set Monthly Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Text(
                'Income for $_currentMonthKey',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Income',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter income amount';
                  }
                  final income = double.tryParse(value);
                  if (income == null || income < 0) {
                    return 'Enter a valid positive amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveIncome,
                child: const Text('Save Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
