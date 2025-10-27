import 'package:flutter/material.dart';

import 'package:grocerystore/data/dummy_items.dart';
import 'package:grocerystore/screens/new_item.dart';

class Grocerylist extends StatelessWidget {
  const Grocerylist({super.key});

  void _addNewItemScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NewItem();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: groceryItems[index].category.color,
              ),
            ),
          );
        },
      ),
    );
  }
}
