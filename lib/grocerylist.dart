import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocerystore/data/categories.dart';
import 'package:http/http.dart' as http;

import 'package:grocerystore/models/grocery_item.dart';
import 'package:grocerystore/screens/new_item.dart';

class Grocerylist extends StatefulWidget {
  const Grocerylist({super.key});

  @override
  State<Grocerylist> createState() => _GrocerylistState();
}

class _GrocerylistState extends State<Grocerylist> {
  List<GroceryItem> groceryItemsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() async {
    final uri = Uri.https(
      "grocery-store-38c6a-default-rtdb.firebaseio.com",
      "grocerystore.json",
    );

    final result = await http.get(uri);

    final listData = json.decode(result.body);

    final List<GroceryItem> tempList = [];

    if (listData == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    for (final item in listData.entries) {
      final category = categories.values.firstWhere((cat) {
        return cat.title == item.value['category'];
      });

      tempList.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      groceryItemsList = tempList;
      isLoading = false;
    });
  }

  void _addNewItemScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
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

    if (isLoading) {
      content = Center(child: CircularProgressIndicator());
    }

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
              trailing: Text(groceryItemsList[index].quantity.toString()),
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
