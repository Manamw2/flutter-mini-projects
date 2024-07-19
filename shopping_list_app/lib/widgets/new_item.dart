import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  var _tittle = '';
  var _quantity = 1;
  var _cat = categories[Categories.vegetables]!;
  final _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  void addItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _inProgress = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https('flutter-learn-397eb-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _tittle,
          'quantity': _quantity,
          'category': _cat.title,
        }),
      );
      final resData = jsonDecode(response.body);
      if (mounted) {
        Navigator.of(context).pop(GroceryItem(
            id: resData['name'],
            name: _tittle,
            quantity: _quantity,
            category: _cat));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _tittle,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Tittle"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tittle = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: _quantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _quantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _cat,
                      onChanged: (value) {
                        setState(() {
                          _cat = value!;
                        });
                      },
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _inProgress
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text("Cancel")),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                      onPressed: _inProgress ? null : addItem,
                      child: _inProgress
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text("Save Item"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
