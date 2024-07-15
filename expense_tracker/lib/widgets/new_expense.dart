import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.onAddExpense, super.key});
  final void Function(Expense expense) onAddExpense;
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _expenseDate;
  Category _selectedCategory = Category.food;

  void _openDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final expenseDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _expenseDate = expenseDate;
    });
  }

  void _onSelectCategory(selected) {
    setState(() {
      if (selected != null) {
        _selectedCategory = selected;
      }
    });
  }

  void _submitExpense() {
    var title = _titleController.text;
    var amount = double.tryParse(_amountController.text);
    var date = _expenseDate;
    var category = _selectedCategory;
    if (title.trim().isNotEmpty || amount != null || date != null) {
      widget.onAddExpense(Expense(
          title: title, amount: amount!, date: date!, category: category));
          Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Inputs"),
          content: const Text("Please, make sure all data are submitted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 30,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      maxLength: 30,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text("Amount"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Row(
                    children: [
                      Text(_expenseDate == null
                          ? "No Date Selected"
                          : formatter.format(_expenseDate!)),
                      IconButton(
                          onPressed: _openDatePicker,
                          icon: const Icon(Icons.date_range)),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                              value: category, child: Text(category.name)))
                          .toList(),
                      onChanged: _onSelectCategory),
                  const Spacer(),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: _submitExpense,
                      child: const Text("Save Expense"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
