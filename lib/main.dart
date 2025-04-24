import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction_model.dart';
import 'services/transaction_service.dart';
import 'providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(ExpenseCategoryAdapter());

  await Hive.openBox<TransactionModel>('transactions');

  // Adding a sample transaction
  await TransactionService.addTransaction(
    TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Lunch at cafe',
      amount: 200,
      category: ExpenseCategory.food,
      date: DateTime.now(),
    ),
  );

  // Getting all transactions
  final allTransactions = await TransactionService.getAllTransactions();
  // print(allTransactions.length);
  debugPrint('Total transactions: ${allTransactions.length}');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      themeMode: themeProvider.currentTheme,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: const MainScreen(),
    );
  }
}
