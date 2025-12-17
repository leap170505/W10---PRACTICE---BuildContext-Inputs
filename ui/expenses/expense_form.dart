import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.food;
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  void showWarningDialog ( String title, String content) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Okay')
            )
          ],
        ),
      );
  }
  //DatePicker
  void _datePicker () async {
    final now = DateTime.now();
    final pickdate = await showDatePicker(
      context: context,
      initialDate: now, 
      firstDate: DateTime(now.year - 1),
      lastDate: now
    );
    if ( pickdate == null ) return;
    setState(() {
      _selectedDate = pickdate;
    });
  }
  void onCreate() {
    //  1 Build an expense
    String title = _titleController.text;
    double? amount = double.tryParse(_amountController.text);
    Category category = _selectedCategory; 

    if (_selectedDate == null) {
    showWarningDialog('Invalid input', 'Please select a date');
    return;
    }

    DateTime date = _selectedDate!;

    if ( title.isEmpty ){
      showWarningDialog('Invalid input', 'The title can not be empty');
      return;
    }
    if ( amount == null || amount <= 0 ){
      showWarningDialog('Invalid input', 'The amount shall be a positive number');
      return;
    }
    Expense newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    // 2 Close the modal and return new 
    Navigator.pop( context, newExpense );
  }

  void onCancel() {
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          SizedBox(height: 20),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(label: Text("Amount")),
            maxLength: 50,
          ),
          SizedBox(height: 20),
          //DropdownButton Category
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values.map((cagegory){
                  return DropdownMenuItem(
                    value: cagegory,
                    child: Text(cagegory.name.toLowerCase()),
                  );
                }).toList(), 
                onChanged: (value){
                  if (value == null ) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              ),
              Spacer(),
              Expanded(
                child: Text(
                  _selectedDate == null ? 'No Date Seleted' : 'Seleted date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
              ),
              IconButton(
                onPressed: _datePicker,
                 icon: Icon(Icons.calendar_month),
              )
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
          SizedBox(height: 20),
          ElevatedButton(onPressed: onCreate, child: Text("Save Expend")),
        ],
      ),
    );
  }
}
