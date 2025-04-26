import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'models/transaction_model.dart';
import 'providers/theme_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/main_screen.dart';
// import 'services/transaction_service.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init(); // Initialize Hive properly

  // Optional: Debugging
  // final allTransactions = await TransactionService.getAllTransactions();
  // debugPrint('📦 Total Transactions: ${allTransactions.length}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
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
        },
      ),
    );
  }
}
