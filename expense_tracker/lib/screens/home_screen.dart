import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/add_expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  void _openAddExpenseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: AddExpense(onAdd: _addNewExpense),
        );
      },
    );
  }

  void _addNewExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddExpenseModal(context),
          ),
        ],
      ),
      body:
          _expenses.isEmpty
              ? const Center(child: Text('No expenses yet!'))
              : ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (ctx, index) {
                  final exp = _expenses[index];
                  // return ListTile(
                  //   title: Text(exp.title),
                  //   subtitle: Text('${exp.date.toLocal()}'.split(' ')[0]),
                  //   trailing: Text('₹${exp.amount.toStringAsFixed(2)}'),
                  // );
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        categoryIcons[exp.category],
                        size: 30,
                        color: Colors.deepPurple,
                      ),
                      title: Text(
                        exp.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${exp.date.toLocal()}'.split(' ')[0]),
                      trailing: Text('₹${exp.amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddExpenseModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.travel: Icons.flight_takeoff,
  Category.shopping: Icons.shopping_cart,
  Category.bills: Icons.receipt_long,
  Category.others: Icons.category,
};
