import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../providers/transaction_provider.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionDetailScreen({super.key, this.transaction});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  // ExpenseCategory _selectedCategory = ExpenseCategory.food;
  late ExpenseCategory _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.transaction?.title ?? '',
    );
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _noteController = TextEditingController(
      text: widget.transaction?.note ?? '',
    );
    _selectedDate = widget.transaction?.date ?? DateTime.now();
    if (widget.transaction != null) {
      _selectedCategory = widget.transaction!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final txn = TransactionModel(
        id:
            widget.transaction?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory,
        // date: DateTime.now(),
        date: _selectedDate,
        note: _noteController.text.trim(),
        type:
            widget.transaction?.type ??
            TransactionType.expense, // Add the required 'type' parameter
      );

      if (widget.transaction == null) {
        await TransactionService.addTransaction(txn);
      } else {
        await TransactionService.updateTransaction(txn);
      }

      if (!mounted) return;
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).loadTransactions();
      Navigator.pop(context);
    }
  }

  void _deleteTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Delete Transaction"),
            content: const Text(
              "Are you sure you want to delete this transaction?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await TransactionService.deleteTransaction(widget.transaction!.id);
      if (!mounted) return;
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).loadTransactions();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
        actions: [
          if (widget.transaction != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTransaction,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final amount = double.tryParse(val);
                  if (amount == null || amount <= 0)
                    return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExpenseCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    'Pick Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
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
                onPressed: _saveTransaction,
                child: Text(
                  widget.transaction == null
                      ? 'Add Transaction'
                      : 'Update Transaction',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
