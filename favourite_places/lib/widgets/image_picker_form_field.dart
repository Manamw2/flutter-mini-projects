import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerFormField extends FormField<File> {
  final BuildContext context;
  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    required this.context,
  }) : super(
          builder: (FormFieldState<File> state) {
            final picker = ImagePicker();
            void pickImage() async {
              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);

              if (pickedFile != null) {
                state.didChange(File(pickedFile.path));
              }
            }

            Widget content = TextButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text('Take Picture'),
              onPressed: () {
                pickImage();
              },
            );

            if (state.value != null) {
              content = GestureDetector(
                onTap: pickImage,
                child: Image.file(
                  state.value!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            }

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),
                  height: 250,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: content,
                ),
                if (!state.isValid)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        state.errorText ?? '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
