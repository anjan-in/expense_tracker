import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedCurrency = 'USD';

  final List<String> currencies = ['USD', 'EUR', 'INR', 'JPY', 'GBP'];

  void _confirmClearData() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Clear All Data?'),
            content: const Text(
              'This action is irreversible. Do you want to proceed?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data cleared!')),
                  );
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCurrencyPreference();
  }

  Future<void> _loadCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';
    });
  }

  Future<void> _saveCurrencyPreference(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(val),
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency'),
            trailing: DropdownButton<String>(
              value: selectedCurrency,
              items:
                  currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
              onChanged: (val) {
                // if (val != null) setState(() => selectedCurrency = val);
                if (val != null) {
                  setState(() => selectedCurrency = val);
                  _saveCurrencyPreference(val);
                }
              },
              // items:
              //     currencies
              //         .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              //         .toList(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Backup & Restore (Coming Soon)'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear All Data'),
            onTap: _confirmClearData,
          ),
          // (Currency selector and other items remain same)
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Settings')),
  //     body: ListView(
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         SwitchListTile(
  //           title: const Text('Dark Mode'),
  //           value: isDarkMode,
  //           onChanged: (val) => setState(() => isDarkMode = val),
  //           secondary: const Icon(Icons.dark_mode),
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.attach_money),
  //           title: const Text('Currency'),
  //           trailing: DropdownButton<String>(
  //             value: selectedCurrency,
  //             onChanged: (val) {
  //               if (val != null) setState(() => selectedCurrency = val);
  //             },
  //             items:
  //                 currencies
  //                     .map((c) => DropdownMenuItem(value: c, child: Text(c)))
  //                     .toList(),
  //           ),
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.restore),
  //           title: const Text('Backup & Restore (Coming Soon)'),
  //           onTap: () {},
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.delete_forever),
  //           title: const Text('Clear All Data'),
  //           onTap: _confirmClearData,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
