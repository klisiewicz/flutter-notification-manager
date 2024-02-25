import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_notification_manager_example/src/provider/notification_provider.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/default_dismissable.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationChannelsPage extends ConsumerWidget {
  final String groupId;

  const NotificationChannelsPage({
    required this.groupId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNotificationChannels = notificationChannelProvider(groupId);
    final asyncChannels = ref.watch(groupNotificationChannels);
    ref.listen(groupNotificationChannels, (previous, next) {
      if (previous == null) return;
      next.maybeWhen(
        error: (error, _) => context.showErrorSnackBar(error),
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
      ),
      body: Center(
        child: asyncChannels.when(
          skipError: true,
          skipLoadingOnReload: true,
          loading: () => const CircularProgressIndicator(),
          data: (channels) {
            return _NotificationChannelList(
              channels: channels,
              onDismissed: (channelId) async {
                await ref
                    .read(groupNotificationChannels.notifier)
                    .delete(id: channelId);
              },
            );
          },
          error: (err, stack) => Text('$err'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.goNamed(
            'add_channel',
            pathParameters: {
              'groupId': groupId,
            },
          );
        },
      ),
    );
  }
}

class _NotificationChannelList extends StatelessWidget {
  final List<NotificationChannel> channels;
  final ValueSetter<String> onDismissed;

  const _NotificationChannelList({
    required this.channels,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        return DefaultDismissable(
          id: channel.id,
          onDismissed: () => onDismissed(channel.id),
          child: ListTile(
            title: Text('${channel.name} (${channel.id})'),
            trailing: Text(channel.importance.name),
            subtitle: Wrap(
              spacing: 4,
              children: [
                if (channel.showBubble) const Text('Bubble'),
                if (channel.showBadge) const Text('Badge'),
                if (channel.enableLights) const Text('Lights'),
                if (channel.enableVibrations) const Text('Vibrations'),
              ],
            ),
          ),
        );
      },
    );
  }
}
