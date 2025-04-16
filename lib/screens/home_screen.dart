import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/add_expense.dart';
import '../widgets/expense_card.dart';

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

  void _openEditExpenseModal(Expense oldExpense, int index) {
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
          child: AddExpense(
            existingExpense: oldExpense,
            onAdd: _addNewExpense,
            onUpdate: (updatedExpense) {
              setState(() {
                _expenses[index] = updatedExpense;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Expense updated')));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () => _openAddExpenseModal(context),
        //   ),
        // ],
      ),
      body:
          _expenses.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.inbox, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No expenses yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (ctx, index) {
                  final exp = _expenses[index];
                  return Dismissible(
                    key: ValueKey(exp.title + exp.date.toIso8601String()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    onDismissed: (_) {
                      final removedExpense = _expenses[index];
                      final removedIndex = index;

                      setState(() {
                        _expenses.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Expense deleted'),
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                _expenses.insert(removedIndex, removedExpense);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: ExpenseCard(
                      expense: exp,
                      onLongPress: () => _openEditExpenseModal(exp, index),
                    ),
                    // child: Card(
                    //   margin: const EdgeInsets.symmetric(
                    //     horizontal: 16,
                    //     vertical: 8,
                    //   ),
                    //   elevation: 4,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: InkWell(
                    //     onLongPress: () => _openEditExpenseModal(exp, index),
                    //     borderRadius: BorderRadius.circular(12),
                    //     child: Container(
                    //       padding: const EdgeInsets.all(16),
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(12),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.1),
                    //             blurRadius: 6,
                    //             offset: const Offset(0, 2),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           CircleAvatar(
                    //             radius: 26,
                    //             backgroundColor: Colors.deepPurple.shade50,
                    //             child: Icon(
                    //               categoryIcons[exp.category],
                    //               color: Colors.deepPurple,
                    //               size: 28,
                    //             ),
                    //           ),
                    //           const SizedBox(width: 16),
                    //           Expanded(
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   exp.title,
                    //                   style: const TextStyle(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 16,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 4),
                    //                 Text(
                    //                   '${exp.date.toLocal()}'.split(' ')[0],
                    //                   style: const TextStyle(
                    //                     color: Colors.grey,
                    //                     fontSize: 13,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Text(
                    //             '₹${exp.amount.toStringAsFixed(2)}',
                    //             style: const TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 16,
                    //               color: Colors.deepPurple,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    //   child: ListTile(
                    //     leading: Icon(
                    //       categoryIcons[exp.category],
                    //       size: 30,
                    //       color: Colors.deepPurple,
                    //     ),
                    //     title: Text(
                    //       exp.title,
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     subtitle: Text('${exp.date.toLocal()}'.split(' ')[0]),
                    //     trailing: Text('₹${exp.amount.toStringAsFixed(2)}'),
                    //     onLongPress: () => _openEditExpenseModal(exp, index),
                    //   ),
                    // ),
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _openAddExpenseModal(context),
        child: const Icon(Icons.add, color: Colors.white),
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
