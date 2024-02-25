import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@isTest
void testAndroid(
  String description,
  WidgetTesterCallback callback, {
  required int sdk,
  int minSdk = 0,
  int maxSdk = 99,
  bool skip = false,
  Timeout? timeout,
  bool semanticsEnabled = true,
  dynamic tags,
  int? retry,
}) {
  testWidgets(
    description,
    callback,
    skip: skip || !Platform.isAndroid || sdk > maxSdk || sdk < minSdk,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: TargetPlatformVariant.only(TargetPlatform.android),
    tags: tags,
    retry: retry,
  );
}
