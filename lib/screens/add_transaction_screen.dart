import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType initialType;

  const AddTransactionScreen({super.key, required this.initialType});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TransactionType _selectedType;
  late DateTime _selectedDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  // final TextEditingController _categoryController = TextEditingController();
  ExpenseCategory? _selectedCategory;

  List<ExpenseCategory> get filteredCategories {
    if (_selectedType == TransactionType.income) {
      return [
        ExpenseCategory.salary,
        ExpenseCategory.freelance,
        ExpenseCategory.investment,
      ];
    } else {
      return [
        ExpenseCategory.food,
        ExpenseCategory.travel,
        ExpenseCategory.shopping,
        ExpenseCategory.entertainment,
        ExpenseCategory.bills,
        ExpenseCategory.health,
        ExpenseCategory.education,
        ExpenseCategory.other,
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType; // Initialize with passed value
    _selectedDate = DateTime.now(); // Initialize with current date
    _selectedCategory = ExpenseCategory.food; // Default category,
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    // _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final newTransaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory!,
        date: _selectedDate,
        note: _noteController.text.trim(),
        type: _selectedType,
      );

      await TransactionService.addTransaction(newTransaction);

      // Update the Monthly Income Box if it's an income transaction
      if (newTransaction.type == TransactionType.income) {
        final incomeBox = Hive.box<MonthlyIncome>('monthlyIncomeBox');
        final monthKey = DateFormat('yyyy-MM').format(newTransaction.date);

        final existingIncome = incomeBox.get(monthKey)?.income ?? 0.0;
        final updatedIncome = existingIncome + newTransaction.amount;

        await incomeBox.put(
          monthKey,
          MonthlyIncome(month: monthKey, income: updatedIncome),
        );
      }

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(newTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  // void _saveTransaction() {
  //   if (_formKey.currentState!.validate()) {
  //     final newTransaction = TransactionModel(
  //       id: DateTime.now().millisecondsSinceEpoch.toString(),
  //       title: _titleController.text.trim(),
  //       amount: double.parse(_amountController.text.trim()),
  //       category: _selectedCategory!,
  //       date: _selectedDate,
  //       note: _noteController.text.trim(),
  //       type: _selectedType,
  //     );

  //     // Save the transaction using the TransactionService
  //     TransactionService.addTransaction(newTransaction)
  //         .then((_) {
  //           // ignore: use_build_context_synchronously
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Transaction added successfully')),
  //           );
  //         })
  //         .catchError((error) {
  //           // ignore: use_build_context_synchronously
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Failed to add transaction')),
  //           );
  //         });

  //     Provider.of<TransactionProvider>(
  //       context,
  //       listen: false,
  //     ).addTransaction(newTransaction);

  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<TransactionType>(
                value: _selectedType,
                onChanged: (val) => setState(() => _selectedType = val!),
                decoration: const InputDecoration(labelText: 'Type'),
                items:
                    TransactionType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExpenseCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                items:
                    ExpenseCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Select Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
