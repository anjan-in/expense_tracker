import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpense extends StatefulWidget {
  final Function(Expense) onAdd;

  const AddExpense({super.key, required this.onAdd});

  String getCategoryIcon(Category category) {
    switch (category) {
      case Category.food:
        return '🍔';
      case Category.travel:
        return '🚗';
      case Category.entertainment:
        return '🎬';
      case Category.shopping:
        return '🛍️';
      case Category.others:
      default:
        return '💡';
    }
  }

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;
  Category? selectedCategory;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.tryParse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount == null || selectedDate == null)
      return;

    widget.onAdd(
      Expense(
        title: enteredTitle,
        amount: enteredAmount,
        date: selectedDate!,
        category: Category.others,
      ),
    );

    Navigator.of(context).pop(); // close the modal
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((picked) {
      if (picked == null) return;
      setState(() {
        selectedDate = picked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 🔐 Attach the key
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount.';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount greater than 0.';
              }
              return null;
            },
          ),
          Row(
            children: [
              Text(
                selectedDate == null
                    ? 'No date chosen!'
                    : 'Picked: ${selectedDate!.toLocal()}'.split(' ')[0],
              ),
              TextButton(
                onPressed: _presentDatePicker,
                child: const Text('Choose Date'),
              ),
            ],
          ),
          DropdownButtonFormField<Category>(
            value: selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            validator: (value) {
              if (value == null) {
                return 'Please select a category.';
              }
              return null;
            },
            items:
                Category.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && selectedDate != null) {
                _submitData(); // ✅ submit only if valid
              } else if (selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please choose a date!')),
                );
              }
            },
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}
