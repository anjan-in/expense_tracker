import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType initialType;

  const AddTransactionScreen({super.key, required this.initialType});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TransactionType _selectedType;
  String title = '';
  double amount = 0.0;
  DateTime selectedDate = DateTime.now();
  String category = '';

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType; // 🛠 Initialize with passed value
  }

  void _saveTransaction() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // TODO: Save the transaction to Hive or Provider
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<TransactionType>(
                value: _selectedType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
                items:
                    TransactionType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value ?? '',
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved:
                    (value) => amount = double.tryParse(value ?? '0') ?? 0.0,
                validator: (value) => value!.isEmpty ? 'Enter an amount' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
