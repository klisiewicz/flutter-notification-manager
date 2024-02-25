import 'dart:async';

import 'package:flutter/material.dart';

class DefaultDismissable extends StatelessWidget {
  final String id;
  final VoidCallback onDismissed;
  final Widget child;

  const DefaultDismissable({
    required this.id,
    required this.onDismissed,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => onDismissed(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
      child: child,
    );
  }
}
