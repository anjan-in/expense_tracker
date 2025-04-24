import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/currency_helper.dart';
import '../providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadCurrencyPreference();
    Future.microtask(
      () =>
          Provider.of<TransactionProvider>(
            context,
            listen: false,
          ).loadTransactions(),
    );
  }

  Future<void> _loadCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';
    });
  }

  @override
  Widget build(BuildContext context) {
    final symbol = getCurrencySymbol(selectedCurrency);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Greeting / App Title
            Text('Hi Anjan', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Here’s a quick summary of your finances.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            // 💰 Balance Summary Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$symbol 24,500',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          label: 'Income',
                          value: '$symbol 32,000',
                          color: Colors.green,
                        ),
                        _StatItem(
                          label: 'Expense',
                          value: '$symbol 7,500',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ⚡ Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickAction(
                  icon: Icons.add,
                  label: 'Add Expense',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddTransactionScreen(),
                      ),
                    );
                  },
                ),
                _QuickAction(icon: Icons.attach_money, label: 'Add Income'),
                _QuickAction(icon: Icons.camera_alt, label: 'Scan Receipt'),
              ],
            ),

            const SizedBox(height: 32),

            // 🕒 Recent Transactions
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            // ...List.generate(3, (index) => const _TransactionTile()),

            // 🛠️ Dynamic transaction list
            Consumer<TransactionProvider>(
              builder: (context, txnProvider, child) {
                final txns = txnProvider.transactions;
                if (txns.isEmpty) {
                  return const Center(child: Text("No transactions yet."));
                }
                return ListView.builder(
                  itemCount: txns.length,
                  shrinkWrap:
                      true, // important for embedding inside SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // disable inner scrolling
                  itemBuilder: (context, index) {
                    final txn = txns[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(
                          txn.amount >= 0
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: txn.amount >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(txn.title),
                      subtitle: Text(
                        '${txn.category.name} • ${txn.date.toLocal()}',
                      ),
                      trailing: Text(
                        '${txn.amount >= 0 ? '+' : '-'} ₹${txn.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: txn.amount >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // 🔗 View All Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for quick actions
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.deepPurple.shade100,
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 24,
  //         backgroundColor: Colors.deepPurple.shade100,
  //         child: Icon(icon, color: Colors.deepPurple),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(label, style: Theme.of(context).textTheme.bodySmall),
  //     ],
  //   );
  // }
}

// Widget for income/expense stat
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Dummy transaction tile
class _TransactionTile extends StatelessWidget {
  const _TransactionTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.shade100,
        child: const Icon(Icons.fastfood, color: Colors.deepPurple),
      ),
      title: const Text('Food & Drinks'),
      subtitle: const Text('Today, 12:30 PM'),
      trailing: const Text('- ₹150', style: TextStyle(color: Colors.red)),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/expense.dart';
// import '../widgets/add_expense.dart';
// import '../widgets/expense_card.dart';
// import '../widgets/expense_pie_chart.dart';
// import '../widgets/expense_bar_chart.dart';

// enum FilterOption { all, today, thisWeek, thisMonth }

// bool showBarChart = true;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Expense> _expenses = [];
//   FilterOption selectedFilter = FilterOption.thisMonth;

//   List<Expense> get filteredExpenses {
//     final now = DateTime.now();
//     return _expenses.where((expense) {
//       if (selectedFilter == FilterOption.today) {
//         return expense.date.day == now.day &&
//             expense.date.month == now.month &&
//             expense.date.year == now.year;
//       } else if (selectedFilter == FilterOption.thisWeek) {
//         final weekAgo = now.subtract(const Duration(days: 7));
//         return expense.date.isAfter(weekAgo);
//       } else if (selectedFilter == FilterOption.thisMonth) {
//         return expense.date.month == now.month && expense.date.year == now.year;
//       } else {
//         return true;
//       }
//     }).toList();
//   }

//   double get total {
//     return filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
//   }

//   void _openAddExpenseModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder:
//           (ctx) => AnimatedPadding(
//             duration: const Duration(milliseconds: 300),
//             padding: MediaQuery.of(ctx).viewInsets,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: AddExpense(
//                 onAdd: (expense) {
//                   setState(() {
//                     _expenses.add(expense);
//                   });
//                 },
//               ),
//             ),
//           ),
//     );
//   }

//   void _addNewExpense(Expense expense) {
//     setState(() {
//       _expenses.add(expense);
//     });
//   }

//   void _openEditExpenseModal(Expense oldExpense, int index) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder:
//           (ctx) => AnimatedPadding(
//             duration: const Duration(milliseconds: 300),
//             padding: MediaQuery.of(ctx).viewInsets,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: AddExpense(
//                 existingExpense: oldExpense,
//                 onAdd: _addNewExpense,
//                 onUpdate: (updatedExpense) {
//                   setState(() {
//                     _expenses[index] = updatedExpense;
//                   });
//                 },
//               ),
//             ),
//           ),
//     );
//   }

//   void removeExpense(int index) {
//     setState(() {
//       _expenses.removeAt(index);
//     });
//   }

//   Widget _buildFilterButton(FilterOption filter, String label) {
//     final isSelected = selectedFilter == filter;
//     return ChoiceChip(
//       label: Text(label),
//       selected: isSelected,
//       onSelected: (_) {
//         setState(() {
//           selectedFilter = filter;
//         });
//       },
//       selectedColor: Colors.deepPurple,
//       labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Expense Tracker',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         foregroundColor: Colors.black,
//         // actions: [
//         //   IconButton(
//         //     onPressed: () => _openAddExpenseModal(context),
//         //     icon: const Icon(Icons.add),
//         //   ),
//         // ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.deepPurple,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         onPressed: () => _openAddExpenseModal(context),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Total Expense Summary Card
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               color: Colors.deepPurple.shade100,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Total Spent', style: TextStyle(fontSize: 16)),
//                     Text(
//                       '₹${total.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Filter Tabs
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildFilterButton(FilterOption.all, 'All'),
//                   const SizedBox(width: 8),
//                   _buildFilterButton(FilterOption.today, 'Today'),
//                   const SizedBox(width: 8),
//                   _buildFilterButton(FilterOption.thisWeek, 'This Week'),
//                   const SizedBox(width: 8),
//                   _buildFilterButton(FilterOption.thisMonth, 'This Month'),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 8),

//             // ExpensePieChart(expenses: filteredExpenses),
//             // const SizedBox(height: 16),
//             // ExpenseBarChart(expenses: filteredExpenses),
//             Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Bar'),
//                     Switch(
//                       value: showBarChart,
//                       onChanged: (value) {
//                         setState(() {
//                           showBarChart = value;
//                         });
//                       },
//                     ),
//                     Text('Pie'),
//                   ],
//                 ),
//                 showBarChart
//                     ? ExpenseBarChart(expenses: filteredExpenses)
//                     : ExpensePieChart(expenses: filteredExpenses),
//               ],
//             ),

//             // Expenses List
//             Expanded(
//               child:
//                   filteredExpenses.isEmpty
//                       ? const Center(
//                         child: Text(
//                           'No expenses to show.',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                       )
//                       : ListView.builder(
//                         itemCount: filteredExpenses.length,
//                         itemBuilder: (ctx, index) {
//                           final expense = filteredExpenses[index];
//                           return Dismissible(
//                             key: ValueKey(
//                               expense.title + expense.date.toIso8601String(),
//                             ),
//                             direction: DismissDirection.endToStart,
//                             background: Container(
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                               ),
//                               alignment: Alignment.centerRight,
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.delete,
//                                 color: Colors.white,
//                                 size: 28,
//                               ),
//                             ),
//                             onDismissed: (_) {
//                               final removedExpense = _expenses[index];
//                               final removedIndex = index;
//                               setState(() {
//                                 _expenses.removeAt(index);
//                               });
//                               ScaffoldMessenger.of(context).clearSnackBars();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: const Text('Expense deleted'),
//                                   duration: const Duration(seconds: 4),
//                                   action: SnackBarAction(
//                                     label: 'Undo',
//                                     onPressed: () {
//                                       setState(() {
//                                         _expenses.insert(
//                                           removedIndex,
//                                           removedExpense,
//                                         );
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: ExpenseCard(
//                               expense: expense,
//                               onLongPress:
//                                   () => _openEditExpenseModal(
//                                     expense,
//                                     _expenses.indexOf(expense),
//                                   ),
//                             ),
//                           );
//                         },
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// const categoryIcons = {
//   Category.food: Icons.fastfood,
//   Category.travel: Icons.flight_takeoff,
//   Category.shopping: Icons.shopping_cart,
//   Category.bills: Icons.receipt_long,
//   Category.others: Icons.category,
// };
