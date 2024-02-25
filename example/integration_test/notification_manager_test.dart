import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'android_tester.dart';

Future<void> main() async {
  final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late NotificationManager notificationManager;

  setUp(() {
    notificationManager = const NotificationManager();
  });

  group('notification group', () {
    testAndroid(
      'should NOT return any groups when no was created',
      (tester) async {
        final groups = await notificationManager.getNotificationChannelGroups();

        expect(groups, isEmpty);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should return null when getting a group for none existing id',
      (tester) async {
        final group =
            await notificationManager.getNotificationChannelGroup('-1');

        expect(group, isNull);
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should return a groups when created',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: id),
        );

        final groups = await notificationManager.getNotificationChannelGroups();

        expect(groups, hasLength(1));

        final group = groups.first;
        expect(group.id, id);
        expect(group.name, isNull);
        expect(group.description, isNull);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should NOT create a group when running SDK below 26',
      (tester) async {
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: randomId()),
        );

        final groups = await notificationManager.getNotificationChannelGroups();
        expect(groups, isEmpty);
      },
      sdk: sdk,
      maxSdk: 25,
    );

    testAndroid(
      'should NOT return any groups when running SDK below 26',
      (tester) async {
        final groups = await notificationManager.getNotificationChannelGroups();

        expect(groups, isEmpty);
      },
      maxSdk: 25,
      sdk: sdk,
    );

    testAndroid(
      'should return a group by id when created',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: id, name: 'Name'),
        );

        final group =
            (await notificationManager.getNotificationChannelGroup(id))!;
        expect(group.id, id);
        expect(group.name, 'Name');
        expect(group.description, isNull);
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should NOT return a group by id when created and running on SDK 26',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: id),
        );

        final group = await notificationManager.getNotificationChannelGroup(id);
        expect(group, isNull);
      },
      minSdk: 26,
      sdk: sdk,
      maxSdk: 26,
    );

    testAndroid(
      'should create a group with description when running SDK 27+',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(
            id: id,
            name: 'Name',
            description: 'Description',
          ),
        );

        final group =
            (await notificationManager.getNotificationChannelGroup(id))!;
        expect(group, isNotNull);
        expect(group.id, id);
        expect(group.name, 'Name');
        expect(group.description, 'Description');
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should create a group without description when running SDK 26',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(
            id: id,
            name: 'Name',
            description: 'Description',
          ),
        );

        final groups = await notificationManager.getNotificationChannelGroups();
        final group = groups.firstWhere((gr) => gr.id == id);
        expect(group.id, id);
        expect(group.name, 'Name');
        expect(group.description, isNull);
      },
      minSdk: 26,
      sdk: sdk,
      maxSdk: 26,
    );

    testAndroid(
      'should update a group when recreating it',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(
            id: id,
            name: 'Name',
            description: 'Description',
          ),
        );

        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(
            id: id,
            name: 'New name',
            description: 'New description',
          ),
        );

        final group =
            (await notificationManager.getNotificationChannelGroup(id))!;
        expect(group, isNotNull);
        expect(group.id, id);
        expect(group.name, 'New name');
        expect(group.description, 'New description');
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should delete an existing group',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: id),
        );

        await notificationManager.deleteNotificationChannelGroup(id);

        final group = await notificationManager.getNotificationChannelGroup(id);
        expect(group, isNull);
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should delete an existing group with all channels assigned to it',
      (tester) async {
        final groupId = randomId();
        final channelId = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: groupId),
        );
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Channel', groupId: groupId),
        );

        await notificationManager.deleteNotificationChannelGroup(groupId);

        final group =
            await notificationManager.getNotificationChannelGroup(groupId);
        expect(group, isNull);

        final channel =
            await notificationManager.getNotificationChannel(channelId);
        expect(channel, isNull);
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should return normally when deleting none existing group',
      (tester) async {
        await expectLater(
          () async =>
              await notificationManager.deleteNotificationChannelGroup('-1'),
          returnsNormally,
        );
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should create multiple groups',
      (tester) async {
        final group1Id = randomId();
        final group2Id = randomId();

        await notificationManager.createNotificationChannelGroups([
          NotificationChannelGroup(id: group1Id),
          NotificationChannelGroup(id: group2Id),
        ]);

        await expectLater(
          await notificationManager.getNotificationChannelGroup(group1Id),
          isNotNull,
        );
        await expectLater(
          await notificationManager.getNotificationChannelGroup(group2Id),
          isNotNull,
        );
      },
      minSdk: 27,
      sdk: sdk,
    );

    testAndroid(
      'should fail to create a group without id',
      (tester) async {
        const group = NotificationChannelGroup(id: '');

        await expectLater(
          () async =>
              await notificationManager.createNotificationChannelGroup(group),
          throwsPlatformArgumentException(),
        );
      },
      minSdk: 26,
      sdk: sdk,
    );
  });

  group('notification channel', () {
    testAndroid(
      'should NOT return any channels when no was created',
      (tester) async {
        final channels = await notificationManager.getNotificationChannels();

        expect(channels, isEmpty);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should return null when getting a channel for none existing id',
      (tester) async {
        final channel = await notificationManager.getNotificationChannel('-1');

        expect(channel, isNull);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should NOT create any channels when running SDK below 26',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name'),
        );

        final channel =
            await notificationManager.getNotificationChannel(channelId);
        expect(channel, isNull);

        final channels = await notificationManager.getNotificationChannels();
        expect(channels, isEmpty);
      },
      sdk: sdk,
      maxSdk: 25,
    );

    testAndroid(
      'should create a channel',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'Name',
            importance: Importance.high,
            description: 'Description',
            showBadge: true,
            enableVibrations: true,
            enableLights: true,
            lightColor: const Color(0xFFFF00FF),
          ),
        );

        final channels = await notificationManager.getNotificationChannels();
        expect(channels, hasLength(1));
        final channel = channels.first;
        expect(channel.id, channelId);
        expect(channel.name, 'Name');
        expect(channel.importance, Importance.high);
        expect(channel.description, 'Description');
        expect(channel.showBadge, isTrue);
        expect(channel.enableVibrations, isTrue);
        expect(channel.enableLights, isTrue);
        expect(channel.lightColor, const Color(0xFFFF00FF));
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should create a channel with show bubble when running SDK 29',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', showBubble: true),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.showBubble, isTrue);
      },
      minSdk: 29,
      sdk: sdk,
      maxSdk: 29,
    );

    testAndroid(
      'should ignore show bubble when running SDK 30+',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', showBubble: true),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.showBubble, isFalse);
      },
      minSdk: 30,
      sdk: sdk,
    );

    testAndroid(
      'should ignore show bubble when running SDKs 26-28',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', showBubble: true),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.showBubble, isFalse);
      },
      minSdk: 26,
      sdk: sdk,
      maxSdk: 28,
    );

    testAndroid(
      'should fail to create a channel assigned to not existing group',
      (tester) async {
        await expectLater(
          () async => await notificationManager.createNotificationChannel(
            NotificationChannel(id: randomId(), name: 'Name', groupId: '-1'),
          ),
          throwsPlatformArgumentException(),
        );
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should create a channel assigned to a group',
      (tester) async {
        final groupId = randomId();
        final channelId = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: groupId),
        );
        notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', groupId: groupId),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.groupId, groupId);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should fail to create a channel with conversion when parent channel does NOT exists and running SDK 30+',
      (tester) async {
        await expectLater(
          () async => await notificationManager.createNotificationChannel(
            NotificationChannel(
              id: randomId(),
              name: 'Name',
              conversation: Conversation(
                conversationId: 'conversation-id',
                parentChannelId: '-1',
              ),
            ),
          ),
          throwsPlatformArgumentException(),
        );
      },
      minSdk: 30,
      sdk: sdk,
    );

    testAndroid(
      'should create a channel with conversion when parent channel exists and running SDK 30+',
      (tester) async {
        final parentChannelId = randomId();
        final channelId = randomId();

        await notificationManager.createNotificationChannel(
          NotificationChannel(id: parentChannelId, name: 'Name'),
        );

        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'Name',
            conversation: Conversation(
              parentChannelId: parentChannelId,
              conversationId: 'conversation-id',
            ),
          ),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.conversation?.parentChannelId, parentChannelId);
        expect(channel.conversation?.conversationId, 'conversation-id');
      },
      minSdk: 30,
      sdk: sdk,
    );

    testAndroid(
      'should NOT create a channel with conversion when running SDK below 30',
      (tester) async {
        final parentChannelId = randomId();
        final channelId = randomId();

        await notificationManager.createNotificationChannel(
          NotificationChannel(id: parentChannelId, name: 'Name'),
        );

        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'Name',
            conversation: Conversation(
              conversationId: 'conversation-id',
              parentChannelId: parentChannelId,
            ),
          ),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.conversation, isNull);
      },
      minSdk: 26,
      sdk: sdk,
      maxSdk: 29,
    );

    testAndroid(
      'should update a channel name and description when recreating it',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'Name',
            description: 'Description',
            importance: Importance.low,
            showBadge: false,
            enableVibrations: true,
            enableLights: true,
            lightColor: const Color(0xFFFF00FF),
          ),
        );

        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'New name',
            description: 'New description',
            // Changing these values should have no effect
            importance: Importance.high,
            showBadge: true,
            enableVibrations: false,
            enableLights: false,
            lightColor: const Color(0xFF00FFFF),
          ),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.id, channelId);
        expect(channel.name, 'New name');
        expect(channel.description, 'New description');
        // Values unchanged
        expect(channel.importance, Importance.low);
        expect(channel.showBadge, isFalse);
        expect(channel.enableVibrations, isTrue);
        expect(channel.enableLights, isTrue);
        expect(channel.lightColor, const Color(0xFFFF00FF));
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should assign a channel to a group when recreating it',
      (tester) async {
        final groupId = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: groupId),
        );

        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', groupId: null),
        );

        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', groupId: groupId),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.groupId, groupId);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should NOT unassign a channel from a group when recreating it',
      (tester) async {
        final groupId = randomId();
        await notificationManager.createNotificationChannelGroup(
          NotificationChannelGroup(id: groupId),
        );

        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', groupId: groupId),
        );

        await notificationManager.createNotificationChannel(
          NotificationChannel(id: channelId, name: 'Name', groupId: null),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.groupId, groupId);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should delete an existing channel',
      (tester) async {
        final id = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(id: id, name: 'Name'),
        );

        await notificationManager.deleteNotificationChannel(id);

        final channel = await notificationManager.getNotificationChannel(id);
        expect(channel, isNull);
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should return normally when deleting none existing channel',
      (tester) async {
        await expectLater(
          () async => await notificationManager.deleteNotificationChannel('-1'),
          returnsNormally,
        );
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should update name and description when recreating a deleted channel',
      (tester) async {
        final channelId = randomId();
        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'Name',
            description: 'Description',
            importance: Importance.low,
            showBadge: false,
            enableVibrations: true,
            enableLights: true,
            lightColor: const Color(0xFFFF00FF),
          ),
        );
        await notificationManager.deleteNotificationChannel(channelId);

        await notificationManager.createNotificationChannel(
          NotificationChannel(
            id: channelId,
            name: 'New name',
            description: 'New description',
            // Changing these values should have no effect
            importance: Importance.high,
            showBadge: true,
            enableVibrations: false,
            enableLights: false,
            lightColor: const Color(0xFF00FFFF),
          ),
        );

        final channel =
            (await notificationManager.getNotificationChannel(channelId))!;
        expect(channel.id, channelId);
        expect(channel.name, 'New name');
        expect(channel.description, 'New description');
        // Values unchanged
        expect(channel.importance, Importance.low);
        expect(channel.showBadge, isFalse);
        expect(channel.enableVibrations, isTrue);
        expect(channel.enableLights, isTrue);
        expect(channel.lightColor, const Color(0xFFFF00FF));
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should fail to create a channel without id',
      (tester) async {
        const channel = NotificationChannel(id: '', name: 'Name');

        await expectLater(
          () async =>
              await notificationManager.createNotificationChannel(channel),
          throwsPlatformArgumentException(),
        );
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should fail to create a channel without name',
      (tester) async {
        final channel = NotificationChannel(id: randomId(), name: '');

        await expectLater(
          () async =>
              await notificationManager.createNotificationChannel(channel),
          throwsPlatformArgumentException(),
        );
      },
      minSdk: 26,
      sdk: sdk,
    );

    testAndroid(
      'should fail to create a channel with unspecified importance',
      (tester) async {
        final channel = NotificationChannel(
          id: randomId(),
          name: 'Name',
          importance: Importance.unspecified,
        );

        await expectLater(
          () async =>
              await notificationManager.createNotificationChannel(channel),
          throwsPlatformArgumentException(),
        );
      },
      minSdk: 26,
      sdk: sdk,
    );
  });
}

String randomId() {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  return String.fromCharCodes(
    Iterable.generate(
      16,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

Matcher throwsPlatformArgumentException() {
  return throwsPlatformException(code: 'INVALID_ARGUMENT');
}

Matcher throwsPlatformException({
  required String code,
}) {
  return throwsA(
    isA<PlatformException>().having((e) => e.code, 'code', code),
  );
}
