import 'dart:io';

import 'package:favourite_places/models/favourite_place.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/widgets/image_picker_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class NewPlace extends ConsumerStatefulWidget {
  const NewPlace({super.key});
  @override
  ConsumerState<NewPlace> createState() {
    return _NewPlaceState();
  }
}

class _NewPlaceState extends ConsumerState<NewPlace> {
  final _formKey = GlobalKey<FormState>();
  String _tittle = '';
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  label: Text('Tittle'),
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
              ImagePickerFormField(
                context: context,
                initialValue: _image,
                validator: (value) {
                  if (value == null) {
                    return 'Please, You must pick an Image';
                  }
                  return null;
                },
                onSaved: (value) {
                  _image = value!;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text("cancel")),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ref
                              .read(placesProvider.notifier)
                              .addPlace(Place(title: _tittle, image: _image!));
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save Place')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
