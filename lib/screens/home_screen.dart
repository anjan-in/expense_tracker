import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/add_expense.dart';
import '../widgets/expense_card.dart';

enum FilterOption { today, thisWeek, thisMonth }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  FilterOption selectedFilter = FilterOption.thisMonth;

  List<Expense> get filteredExpenses {
    final now = DateTime.now();
    return _expenses.where((expense) {
      if (selectedFilter == FilterOption.today) {
        return expense.date.day == now.day &&
            expense.date.month == now.month &&
            expense.date.year == now.year;
      } else if (selectedFilter == FilterOption.thisWeek) {
        final weekAgo = now.subtract(const Duration(days: 7));
        return expense.date.isAfter(weekAgo);
      } else {
        return expense.date.month == now.month && expense.date.year == now.year;
      }
    }).toList();
  }

  double get total {
    return filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _openAddExpenseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: MediaQuery.of(ctx).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AddExpense(
                onAdd: (expense) {
                  setState(() {
                    _expenses.add(expense);
                  });
                },
              ),
            ),
          ),
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
      builder:
          (ctx) => AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: MediaQuery.of(ctx).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AddExpense(
                existingExpense: oldExpense,
                onAdd: _addNewExpense,
                onUpdate: (updatedExpense) {
                  setState(() {
                    _expenses[index] = updatedExpense;
                  });
                },
              ),
            ),
          ),
    );
  }

  // void _openEditExpenseModal(Expense oldExpense, int index) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (_) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           top: 20,
  //           left: 20,
  //           right: 20,
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //         ),
  //         child: AddExpense(
  //           existingExpense: oldExpense,
  //           onAdd: _addNewExpense,
  //           onUpdate: (updatedExpense) {
  //             setState(() {
  //               _expenses[index] = updatedExpense;
  //             });
  //             ScaffoldMessenger.of(
  //               context,
  //             ).showSnackBar(const SnackBar(content: Text('Expense updated')));
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void removeExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  Widget _buildFilterButton(FilterOption filter, String label) {
    final isSelected = selectedFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          selectedFilter = filter;
        });
      },
      selectedColor: Colors.deepPurple,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Expense Tracker',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: Colors.white,
  //       elevation: 1,
  //       foregroundColor: Colors.black,
  //     ),
  //     body:
  //         _expenses.isEmpty
  //             ? Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: const [
  //                   Icon(Icons.inbox, size: 80, color: Colors.grey),
  //                   SizedBox(height: 16),
  //                   Text(
  //                     'No expenses yet!',
  //                     style: TextStyle(fontSize: 18, color: Colors.grey),
  //                   ),
  //                 ],
  //               ),
  //             )
  //             : ListView.builder(
  //               itemCount: filteredExpenses.length,
  //               // itemCount: _expenses.length,
  //               itemBuilder: (ctx, index) {
  //                 final exp = filteredExpenses[index];
  //                 Card(
  //                   margin: const EdgeInsets.all(12),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   color: Colors.teal.shade50,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           'Total Spent',
  //                           style: TextStyle(fontSize: 14, color: Colors.teal),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           '₹${total.toStringAsFixed(2)}',
  //                           style: const TextStyle(
  //                             fontSize: 22,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children:
  //                         FilterOption.values.map((filter) {
  //                           final isSelected = selectedFilter == filter;
  //                           return ChoiceChip(
  //                             label: Text(
  //                               filter.name.toUpperCase(),
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 color:
  //                                     isSelected ? Colors.white : Colors.teal,
  //                               ),
  //                             ),
  //                             selectedColor: Colors.teal,
  //                             backgroundColor: Colors.teal.shade50,
  //                             selected: isSelected,
  //                             onSelected: (_) {
  //                               setState(() {
  //                                 selectedFilter = filter;
  //                               });
  //                             },
  //                           );
  //                         }).toList(),
  //                   ),
  //                 );
  //                 // final exp = _expenses[index];
  //                 return Dismissible(
  //                   key: ValueKey(exp.title + exp.date.toIso8601String()),
  //                   direction: DismissDirection.endToStart,
  //                   background: Container(
  //                     margin: const EdgeInsets.symmetric(
  //                       horizontal: 16,
  //                       vertical: 8,
  //                     ),
  //                     padding: const EdgeInsets.symmetric(horizontal: 20),
  //                     alignment: Alignment.centerRight,
  //                     decoration: BoxDecoration(
  //                       color: Colors.red,
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: const Icon(
  //                       Icons.delete,
  //                       color: Colors.white,
  //                       size: 28,
  //                     ),
  //                   ),
  //                   onDismissed: (_) {
  //                     final removedExpense = _expenses[index];
  //                     final removedIndex = index;
  //                     setState(() {
  //                       _expenses.removeAt(index);
  //                     });
  //                     ScaffoldMessenger.of(context).clearSnackBars();
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: const Text('Expense deleted'),
  //                         duration: const Duration(seconds: 4),
  //                         action: SnackBarAction(
  //                           label: 'Undo',
  //                           onPressed: () {
  //                             setState(() {
  //                               _expenses.insert(removedIndex, removedExpense);
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   child: ExpenseCard(
  //                     expense: exp,
  //                     onLongPress: () => _openEditExpenseModal(exp, index),
  //                   ),
  //                 );
  //               },
  //             ),
  //     floatingActionButton: FloatingActionButton(
  //       backgroundColor: Colors.deepPurple,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       onPressed: () => _openAddExpenseModal(context),
  //       child: const Icon(Icons.add, color: Colors.white),
  //     ),
  //   );
  // }
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
        //     onPressed: () => _openAddExpenseModal(context),
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _openAddExpenseModal(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Expense Summary Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.deepPurple.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Spent', style: TextStyle(fontSize: 16)),
                    Text(
                      '₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton(FilterOption.today, 'Today'),
                  const SizedBox(width: 8),
                  _buildFilterButton(FilterOption.thisWeek, 'This Week'),
                  const SizedBox(width: 8),
                  _buildFilterButton(FilterOption.thisMonth, 'This Month'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Expenses List
            Expanded(
              child:
                  filteredExpenses.isEmpty
                      ? const Center(
                        child: Text(
                          'No expenses to show.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (ctx, index) {
                          final expense = filteredExpenses[index];
                          return Dismissible(
                            key: ValueKey(
                              expense.title + expense.date.toIso8601String(),
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                                        _expenses.insert(
                                          removedIndex,
                                          removedExpense,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: ExpenseCard(
                              expense: expense,
                              onLongPress:
                                  () => _openEditExpenseModal(
                                    expense,
                                    _expenses.indexOf(expense),
                                  ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
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
