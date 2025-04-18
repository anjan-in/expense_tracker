import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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

    // return MaterialApp(
    //   title: 'Expense Tracker',
    //   theme: ThemeData(
    //     // primarySwatch: Colors.teal,
    //     useMaterial3: true,
    //     scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: const MainScreen(), // 👈 This is where the redirection happens
    //   // home: HomeScreen(),
    //   debugShowCheckedModeBanner: false,
    // );
  }
}
