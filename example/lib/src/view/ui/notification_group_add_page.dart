import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_notification_manager_example/src/provider/notification_provider.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/default_text_field.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationGroupAddPage extends HookConsumerWidget {
  const NotificationGroupAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idController = useTextEditingController();
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Gap(20),
            DefaultTextField(
              controller: idController,
              labelText: 'Id',
            ),
            const Gap(20),
            DefaultTextField(
              controller: nameController,
              labelText: 'Name',
            ),
            const Gap(20),
            DefaultTextField(
              controller: descriptionController,
              labelText: 'Description',
            ),
            const Gap(20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(notificationGroupProvider.notifier).create(
                id: idController.text,
                name: nameController.text,
                description: descriptionController.text,
              );
          context.pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
