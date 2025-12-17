import 'package:app_kom_lu/W8/1%20-%20START%20CODE/EXERCISE-1/ex_1_start.dart';
import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'expense_form.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() {
    return _ExpensesViewState();
  }
}

class _ExpensesViewState extends State<ExpensesView> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];
  // void onAddClicked(BuildContext context) async{
  
  //   showModalBottomSheet(
  //     isScrollControlled: false,
  //     context: context,
  //     builder: (c) => Center(
  //       child: ExpenseForm(  ),
  //     ),
  //   );
  // }
  void _addExpense () async {
    final newExpense = await showModalBottomSheet<Expense>(
      context: context, 
      builder: (context) {
        return const ExpenseForm();
      },
    );
    if (newExpense != null ) {
      setState(() {
        _expenses.add(newExpense);
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text('Ronan-The-Best Expenses App'),
        actions: [
          IconButton(
            onPressed: _addExpense,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return Dismissible(
            key: ValueKey(expense.id),
            direction: DismissDirection.horizontal,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15)
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            secondaryBackground: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15)
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: const Icon(Icons.cancel, color: Colors.white),
            ),
            onDismissed: (direction) => setState(() {
              _expenses.removeAt(index);
            }),
            child: ExpenseItem(expense: expense),
          );
        }
      ),
    );
    
  }
}

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  IconData get expenseIcon {
    switch (expense.category) {
      case Category.food:
        return Icons.free_breakfast;
      case Category.travel:
        return Icons.travel_explore;
      case Category.leisure:
        return Icons.holiday_village;
      case Category.work:
        return Icons.work;
    }
  }

  String get expenseDate {
    return expense.date.toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${expense.amount.toStringAsPrecision(2)} \$"),
                ],
              ),
              Spacer(),
              Row(children: [Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(expenseIcon),
              ), Text(expenseDate)]),
            ],
          ),
        ),
      ),
    );
  }
}
