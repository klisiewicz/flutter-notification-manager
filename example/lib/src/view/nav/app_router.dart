import 'package:flutter_notification_manager_example/src/view/ui/notification_channel_add_page.dart';
import 'package:flutter_notification_manager_example/src/view/ui/notification_channels_page.dart';
import 'package:flutter_notification_manager_example/src/view/ui/notification_group_add_page.dart';
import 'package:flutter_notification_manager_example/src/view/ui/notification_groups_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotificationGroupsPage(),
      routes: [
        GoRoute(
          name: 'add_group',
          path: 'add',
          builder: (context, state) => const NotificationGroupAddPage(),
        ),
        GoRoute(
          name: 'channels',
          path: ':groupId/channels',
          builder: (context, state) {
            final groupId = state.pathParameters['groupId']!;
            return NotificationChannelsPage(groupId: groupId);
          },
          routes: [
            GoRoute(
              name: 'add_channel',
              path: 'add',
              builder: (context, state) {
                final groupId = state.pathParameters['groupId']!;
                return NotificationChannelAddPage(groupId: groupId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
