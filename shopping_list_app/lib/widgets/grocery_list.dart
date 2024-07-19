import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _itemList = [];
  bool _inProgress = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<GroceryItem> items = [];
    final url = Uri.https('flutter-learn-397eb-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      setState(() {
        _inProgress = false;
      });
      return;
    }
    final Map<String, dynamic> resData = jsonDecode(response.body);
    for (final item in resData.entries) {
      Category cat = categories.values
          .firstWhere((category) => item.value['category'] == category.title);
      items.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: cat));
    }
    setState(() {
      _itemList = items;
      _inProgress = false;
    });
  }

  void addItem() async {
    GroceryItem? groceryItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (groceryItem != null) {
      setState(() {
        _itemList.add(groceryItem);
      });
    }
  }

  void removeItem(int index) async {
    final item = _itemList[index];
    _itemList.remove(item);
    final url = Uri.https('flutter-learn-397eb-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _itemList.add(item);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed To Delete Item")));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Item is deleted successfully")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('There is no items avalilable!'),
    );
    if (_inProgress) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_itemList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _itemList.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            setState(() {
              removeItem(index);
            });
          },
          key: ValueKey(_itemList[index].id),
          child: ListTile(
            title: Text(_itemList[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _itemList[index].category.color,
            ),
            trailing: Text(
              _itemList[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
