import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${transaction.title}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Amount: ₹${transaction.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Text('Category: ${transaction.category.name}'),
            const SizedBox(height: 12),
            Text('Date: ${transaction.date.toLocal()}'),
            const SizedBox(height: 12),
            Text('Note: ${transaction.note ?? "-"}'),
          ],
        ),
      ),
    );
  }
}
