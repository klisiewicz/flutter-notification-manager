import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension SnackBarContextExt on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
    String message,
  ) {
    final theme = Theme.of(this);
    final snackBar = SnackBar(
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      backgroundColor: theme.colorScheme.primaryContainer,
    );
    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
    Object error,
  ) {
    final theme = Theme.of(this);
    final snackBar = SnackBar(
      content: Text(
        error.errorMessage,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      backgroundColor: theme.colorScheme.errorContainer,
    );
    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}

extension on Object {
  String get errorMessage {
    var prefix = 'Something went wrong';
    return switch (this) {
      String() => '$prefix:$this',
      PlatformException(message: final msg) =>
        '$prefix${msg != null ? ':$msg' : ''}',
      Exception(message: final msg) => '$prefix:$msg',
      _ => prefix,
    };
  }
}

extension on Exception {
  String get message {
    return toString().startsWith("Exception: ")
        ? toString().substring(11)
        : toString();
  }
}
