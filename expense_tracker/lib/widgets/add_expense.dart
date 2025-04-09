import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpense extends StatefulWidget {
  final Function(Expense) onAdd;

  const AddExpense({super.key, required this.onAdd});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
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
        ElevatedButton(
          onPressed: _submitData,
          child: const Text('Add Expense'),
        ),
        DropdownButtonFormField<Category>(
          value: selectedCategory,
          decoration: InputDecoration(labelText: 'Category'),
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
      ],
    );
  }
}
