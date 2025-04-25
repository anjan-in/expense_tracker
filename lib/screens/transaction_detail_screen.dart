import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../providers/transaction_provider.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionDetailScreen({super.key, this.transaction});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.transaction?.title ?? '',
    );
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _noteController = TextEditingController(
      text: widget.transaction?.note ?? '',
    );
    _selectedDate = widget.transaction?.date ?? DateTime.now();

    if (widget.transaction != null) {
      _selectedCategory = widget.transaction!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final txn = TransactionModel(
        id:
            widget.transaction?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteController.text.trim(),
      );

      if (widget.transaction == null) {
        await TransactionService.addTransaction(txn);
      } else {
        await TransactionService.updateTransaction(txn);
      }

      if (!mounted) return;
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).loadTransactions();
      Navigator.pop(context);
    }
  }

  Future<void> _deleteTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Delete Transaction"),
            content: const Text(
              "Are you sure you want to delete this transaction?",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await TransactionService.deleteTransaction(widget.transaction!.id);
      if (!mounted) return;
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).loadTransactions();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.transaction != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Transaction' : 'Add Transaction'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: _deleteTransaction,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildInputField(
                  controller: _titleController,
                  label: 'Title',
                  icon: Icons.short_text_rounded,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter a title'
                              : null,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _amountController,
                  label: 'Amount',
                  icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter amount'
                              : null,
                ),
                const SizedBox(height: 20),
                _buildCategoryDropdown(),
                const SizedBox(height: 20),
                _buildDatePicker(context),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _noteController,
                  label: 'Note (Optional)',
                  icon: Icons.note_alt_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    if (isEdit)
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: _deleteTransaction,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    if (isEdit) const SizedBox(width: 12),
                    Expanded(
                      flex: isEdit ? 2 : 1,
                      child: ElevatedButton(
                        onPressed: _saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isEdit ? 'Save Changes' : 'Add Transaction',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<ExpenseCategory>(
      value: _selectedCategory,
      items:
          ExpenseCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    color: _getCategoryColor(category),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedCategory = value);
        }
      },
      validator: (value) => value == null ? 'Select a category' : null,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      dropdownColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      isExpanded: true,
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _selectedDate) {
          setState(() => _selectedDate = picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.travel:
        return Icons.directions_car;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.bills:
        return Icons.power;
      case ExpenseCategory.health:
        return Icons.medical_services;
      case ExpenseCategory.education:
        return Icons.school;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.shopping:
        return Colors.blue;
      case ExpenseCategory.travel:
        return Colors.green;
      case ExpenseCategory.entertainment:
        return Colors.purple;
      case ExpenseCategory.bills:
        return Colors.amber;
      case ExpenseCategory.health:
        return Colors.red;
      case ExpenseCategory.education:
        return Colors.indigo;
      case ExpenseCategory.other:
        return Colors.blueGrey;
    }
  }
}

// class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _amountController;
//   late TextEditingController _noteController;
//   ExpenseCategory _selectedCategory = ExpenseCategory.food;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(
//       text: widget.transaction?.title ?? '',
//     );
//     _amountController = TextEditingController(
//       text: widget.transaction?.amount.toString() ?? '',
//     );
//     _noteController = TextEditingController(
//       text: widget.transaction?.note ?? '',
//     );
//     if (widget.transaction != null) {
//       _selectedCategory = widget.transaction!.category;
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _amountController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }

//   void _saveTransaction() async {
//     if (_formKey.currentState!.validate()) {
//       final txn = TransactionModel(
//         id:
//             widget.transaction?.id ??
//             DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleController.text.trim(),
//         amount: double.parse(_amountController.text.trim()),
//         category: _selectedCategory,
//         date: DateTime.now(),
//         note: _noteController.text.trim(),
//       );

//       if (widget.transaction == null) {
//         await TransactionService.addTransaction(txn);
//       } else {
//         await TransactionService.updateTransaction(txn);
//       }

//       if (!mounted) return;
//       Provider.of<TransactionProvider>(
//         context,
//         listen: false,
//       ).loadTransactions();
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       appBar: AppBar(
//         title: Text(
//           widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
//         ),
//         actions: [
//           if (widget.transaction != null)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () async {
//                 final confirm = await showDialog<bool>(
//                   context: context,
//                   builder:
//                       (ctx) => AlertDialog(
//                         title: const Text("Delete Transaction"),
//                         content: const Text(
//                           "Are you sure you want to delete this transaction?",
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(ctx, false),
//                             child: const Text("Cancel"),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.pop(ctx, true),
//                             child: const Text("Delete"),
//                           ),
//                         ],
//                       ),
//                 );

//                 if (confirm == true) {
//                   await TransactionService.deleteTransaction(
//                     widget.transaction!.id,
//                   );
//                   if (!mounted) return;
//                   Provider.of<TransactionProvider>(
//                     context,
//                     listen: false,
//                   ).loadTransactions();
//                   Navigator.pop(context);
//                 }
//               },
//             ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: 'Title'),
//                 validator: (val) => val!.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _amountController,
//                 decoration: const InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.number,
//                 validator: (val) => val!.isEmpty ? 'Required' : null,
//               ),
//               DropdownButtonFormField<ExpenseCategory>(
//                 value: _selectedCategory,
//                 decoration: const InputDecoration(labelText: 'Category'),
//                 onChanged: (val) => setState(() => _selectedCategory = val!),
//                 items:
//                     ExpenseCategory.values.map((cat) {
//                       return DropdownMenuItem(
//                         value: cat,
//                         child: Text(cat.name),
//                       );
//                     }).toList(),
//               ),
//               TextFormField(
//                 controller: _noteController,
//                 decoration: const InputDecoration(labelText: 'Note'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveTransaction,
//                 child: const Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
