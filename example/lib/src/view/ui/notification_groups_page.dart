import 'package:flutter/material.dart';
import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_notification_manager_example/src/provider/notification_provider.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/default_dismissable.dart';
import 'package:flutter_notification_manager_example/src/view/ui/shared/snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationGroupsPage extends ConsumerWidget {
  const NotificationGroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGroups = ref.watch(
      notificationGroupProvider,
    );
    ref.listen(notificationGroupProvider, (previous, next) {
      if (previous == null) return;
      next.maybeWhen(
        error: (error, _) => context.showErrorSnackBar(error),
        orElse: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: Center(
        child: asyncGroups.when(
          skipError: true,
          skipLoadingOnReload: true,
          loading: () => const CircularProgressIndicator(),
          data: (groups) {
            return _NotificationGroupList(
              groups: groups,
              onTapped: (groupId) {
                context.goNamed(
                  'channels',
                  pathParameters: {'groupId': groupId},
                );
              },
              onDismissed: (groupId) async {
                await ref
                    .read(notificationGroupProvider.notifier)
                    .delete(id: groupId);
              },
            );
          },
          error: (err, stack) => Text('$err'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.goNamed('add_group');
        },
      ),
    );
  }
}

class _NotificationGroupList extends StatelessWidget {
  final List<NotificationChannelGroup> groups;
  final ValueSetter<String> onTapped;
  final ValueSetter<String> onDismissed;

  const _NotificationGroupList({
    required this.groups,
    required this.onTapped,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return DefaultDismissable(
          id: group.id,
          onDismissed: () => onDismissed(group.id),
          child: ListTile(
            onTap: () => onTapped.call(group.id),
            title: Text('${group.name} (${group.id})'),
            subtitle: Text(group.description ?? ''),
          ),
        );
      },
    );
  }
}
