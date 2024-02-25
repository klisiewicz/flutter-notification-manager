import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_notification_manager_example/src/provider/notification_provider.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/default_switch.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/default_text_field.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/importance_dropdown.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationChannelAddPage extends HookConsumerWidget {
  final String groupId;

  const NotificationChannelAddPage({
    required this.groupId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idController = useTextEditingController();
    final nameController = useTextEditingController();
    final importanceNotifier = useValueNotifier(
      Importance.none.name,
    );
    final bubbleNotifier = useValueNotifier(true);
    final badgeNotifier = useValueNotifier(true);
    final lightsNotifier = useValueNotifier(true);
    final vibrationNotifier = useValueNotifier(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
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
              ImportanceDropDown(
                notifier: importanceNotifier,
                values: Importance.values.map((it) => it.name).toList(),
              ),
              const Gap(10),
              DefaultSwitch(
                labelText: 'Bubble',
                notifier: bubbleNotifier,
              ),
              const Gap(5),
              DefaultSwitch(
                labelText: 'Badge',
                notifier: badgeNotifier,
              ),
              const Gap(5),
              DefaultSwitch(
                labelText: 'Lights',
                notifier: lightsNotifier,
              ),
              const Gap(5),
              DefaultSwitch(
                labelText: 'Vibrations',
                notifier: vibrationNotifier,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(notificationChannelProvider(groupId).notifier).create(
                id: idController.text,
                name: nameController.text,
                importance: importanceNotifier.value,
                showBadge: badgeNotifier.value,
                showBubble: bubbleNotifier.value,
                enableLights: lightsNotifier.value,
                enableVibrations: vibrationNotifier.value,
              );
          context.pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
