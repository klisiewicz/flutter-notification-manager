import 'package:flutter/material.dart';

class DefaultSwitch extends StatelessWidget {
  final String labelText;
  final ValueNotifier<bool> notifier;

  const DefaultSwitch({
    required this.labelText,
    required this.notifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: notifier,
          builder: (BuildContext context, bool value, Widget? child) {
            return Switch(
              value: value,
              onChanged: (newValue) => notifier.value = newValue,
            );
          },
        ),
      ],
    );
  }
}
