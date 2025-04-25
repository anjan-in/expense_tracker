import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/monthly_income_model.dart';
import 'models/transaction_model.dart';
import 'providers/theme_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/main_screen.dart';
import 'services/transaction_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Hive.initFlutter(); // Web-safe init
  } else {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.initFlutter();
  }

  // ✅ Register adapters only if not already registered
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionModelAdapter()); // typeId = 0
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ExpenseCategoryAdapter()); // typeId = 1
  }
  // if (!Hive.isAdapterRegistered(2)) {
  //   Hive.registerAdapter(MonthlyIncomeAdapter()); // typeId = 2
  // }

  // Open Hive boxes
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<MonthlyIncome>('monthlyIncomeBox');

  // Add a sample transaction
  await TransactionService.addTransaction(
    TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Lunch at cafe',
      amount: 200,
      category: ExpenseCategory.food,
      date: DateTime.now(),
    ),
  );

  final allTransactions = await TransactionService.getAllTransactions();
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

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'models/monthly_income_model.dart';
// import 'screens/main_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/theme_provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'models/transaction_model.dart';
// import 'services/transaction_service.dart';
// import 'providers/transaction_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final appDocumentDir = await getApplicationDocumentsDirectory();
//   Hive.init(appDocumentDir.path);
//   await Hive.initFlutter();

//   Hive.registerAdapter(TransactionModelAdapter());
//   Hive.registerAdapter(ExpenseCategoryAdapter());

//   await Hive.openBox<TransactionModel>('transactions');

//   Hive.registerAdapter(MonthlyIncomeAdapter());
//   await Hive.openBox<MonthlyIncome>('monthlyIncomeBox');

//   // Adding a sample transaction
//   await TransactionService.addTransaction(
//     TransactionModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: 'Lunch at cafe',
//       amount: 200,
//       category: ExpenseCategory.food,
//       date: DateTime.now(),
//     ),
//   );

//   // Getting all transactions
//   final allTransactions = await TransactionService.getAllTransactions();
//   // print(allTransactions.length);
//   debugPrint('Total transactions: ${allTransactions.length}');

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => TransactionProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Expense Tracker',
//       themeMode: themeProvider.currentTheme,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         brightness: Brightness.dark,
//       ),
//       home: const MainScreen(),
//     );
//   }
// }
