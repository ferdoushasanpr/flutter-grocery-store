import 'package:flutter/material.dart';

import 'package:grocerystore/data/dummy_items.dart';
import 'package:grocerystore/models/grocery_item.dart';
import 'package:grocerystore/screens/new_item.dart';

class Grocerylist extends StatefulWidget {
  const Grocerylist({super.key});

  @override
  State<Grocerylist> createState() => _GrocerylistState();
}

class _GrocerylistState extends State<Grocerylist> {
  final List<GroceryItem> groceryItemsList = [...groceryItems];

  void _addNewItemScreen(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NewItem();
        },
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      groceryItemsList.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("Oh no, No Items to Show..."));

    if (groceryItemsList.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItemsList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              setState(() {
                groceryItemsList.remove(groceryItemsList[index]);
              });
            },
            key: ValueKey(groceryItemsList[index].name),
            child: ListTile(
              title: Text(groceryItemsList[index].name),
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: groceryItemsList[index].category.color,
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () {
              _addNewItemScreen(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
