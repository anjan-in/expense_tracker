import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/hive_boxes.dart';
import '../models/transaction_model.dart';
import '../utils/currency_helper.dart';
import '../providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import '../screens/transaction_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrency = 'USD';
  late Box<TransactionModel> transactionBox;
  late Box<MonthlyIncome> incomeBox;
  String currentMonthKey = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadCurrencyPreference();
    transactionBox = Hive.box<TransactionModel>(HiveBoxes.transactions);
    incomeBox = Hive.box<MonthlyIncome>(HiveBoxes.monthlyIncomeBox);

    Future.microtask(
      () =>
          Provider.of<TransactionProvider>(
            context,
            listen: false,
          ).loadTransactions(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForOverspending();
    });
  }

  void _checkForOverspending() {
    final monthlyIncome = incomeBox.get(currentMonthKey)?.income ?? 0.0;
    final monthlyExpense = calculateMonthlyExpenses(transactionBox);

    if (monthlyIncome > 0 && monthlyExpense > monthlyIncome) {
      _showOverspendAlert();
    }
  }

  void _showOverspendAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('⚠️ You have exceeded your monthly budget!'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  double calculateMonthlyExpenses(Box<TransactionModel> transactionBox) {
    final String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    final expenses = transactionBox.values.where((tx) {
      final txMonth = DateFormat('yyyy-MM').format(tx.date);
      return tx.type == TransactionType.expense && txMonth == currentMonth;
    });

    return expenses.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  Future<void> _loadCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';
    });
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📸 Image captured: ${pickedFile.name}')),
      );
      // TODO: You can navigate to OCR screen or process the image here
    }
  }

  @override
  Widget build(BuildContext context) {
    final symbol = getCurrencySymbol(selectedCurrency);
    final monthlyIncome = incomeBox.get(currentMonthKey)?.income ?? 0.0;
    final monthlyExpense = calculateMonthlyExpenses(transactionBox);
    final balance = monthlyIncome - monthlyExpense;

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
                      '$symbol ${balance.toStringAsFixed(2)}',
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
                          value: '$symbol ${monthlyIncome.toStringAsFixed(2)}',
                          color: Colors.green,
                        ),
                        _StatItem(
                          label: 'Expense',
                          value: '$symbol ${monthlyExpense.toStringAsFixed(2)}',
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
                        builder:
                            (_) => const AddTransactionScreen(
                              initialType: TransactionType.expense,
                            ),
                      ),
                    );
                  },
                ),
                _QuickAction(
                  icon: Icons.attach_money,
                  label: 'Add Income',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const AddTransactionScreen(
                              initialType: TransactionType.income,
                            ),
                      ),
                    );
                  },
                ),
                _QuickAction(
                  icon: Icons.camera_alt,
                  label: 'Scan Receipt',
                  onTap: _openCamera,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 🕒 Recent Transactions
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            Consumer<TransactionProvider>(
              builder: (context, txnProvider, child) {
                final txns = txnProvider.transactions;
                if (txns.isEmpty) {
                  return const Center(child: Text("No transactions yet."));
                }
                return ListView.builder(
                  itemCount: txns.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final txn = txns[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(
                          txn.type == TransactionType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color:
                              txn.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      title: Text(txn.title),
                      subtitle: Text(
                        '${txn.category.name} • ${DateFormat('dd MMM yyyy').format(txn.date)}',
                      ),
                      trailing: Text(
                        '${txn.type == TransactionType.income ? '+' : '-'} $symbol${txn.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color:
                              txn.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    TransactionDetailScreen(transaction: txn),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to All Transactions Screen
                },
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
