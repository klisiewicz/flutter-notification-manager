import 'package:flutter/material.dart';

class ImportanceDropDown extends StatelessWidget {
  final ValueNotifier<String> notifier;
  final List<String> values;

  const ImportanceDropDown({
    required this.notifier,
    required this.values,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: notifier.value,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Importance',
      ),
      onChanged: (String? value) {
        if (value != null) {
          notifier.value = value;
        }
      },
      items: values.map<DropdownMenuItem<String>>((importance) {
        return DropdownMenuItem<String>(
          value: importance,
          child: Text(importance),
        );
      }).toList(),
    );
  }
}
