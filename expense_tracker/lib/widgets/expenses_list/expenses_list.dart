import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({required this.expenses, required this.onDismissExpense, super.key});
  final List<Expense> expenses;
  final void Function(Expense expense) onDismissExpense;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, idx) => Dismissible(
          background: Container(color : Theme.of(context).colorScheme.error.withOpacity(0.75)),
          onDismissed: (direction) => onDismissExpense(expenses[idx]),
          key: ValueKey(expenses[idx].id),
          child: ExpenseItem(expense: expenses[idx])));
  }
}
