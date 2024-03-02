# Flutter Notification Manager

Android Notification Manager plugin that allows to create and manage notification channels.

## Create a notification channel

You can create a notification channel by calling `createNotificationChannel()` :

```dart
const notificationManager = NotificationManager(); 
await notificationManager.createNotificationChannel(
  NotificationChannel(
    id: 'my_channel_01',
    name: 'My First Channel',
    importance: Importance.standard,
  ),
);
```
Recreating an existing notification channel with its original values performs no operation, so it's safe to call this code when starting an app.

❗ After you create a notification channel, you can't change the notification behaviors. However, you can still change a channel's name and description.

## Read notification channel settings

You can read notification channel setting by calling `getNotificationChannel()` or `getNotificationChannels()`.

```dart
const notificationManager = NotificationManager();  
final myChannel = await notificationManager.getNotificationChannel('my_channel_01');  
final allChannels = await notificationManager.getNotificationChannels();
```

## Open the notification channel settings

Not supported yet.

## Delete a notification channel

You can delete notification channels by calling `deleteNotificationChannel()`:

```dart
const notificationManager = NotificationManager();
notificationManager.deleteNotificationChannel('my_channel_01');
```

## Create a notification channel group

Each notification channel group requires an ID, which must be unique within your package, as well as a user-visible name.

```dart
const notificationManager = NotificationManager();
const group = NotificationChannelGroup(id: 'my_group_01', name: 'My first group');
notificationManager.createNotificationChannelGroup(group);
```
After you create a new group, you can assign a `NotificationChannel` to that group by passing `groupId` constructor parameter:

```dart
const channel = NotificationChannel(
  // ...
  groupId: 'my_group_01',
);
```

❗ Afater you submit the channel to the notification manager, you cannot change the association between notification channel and group.

## Backward Compatibility

The Support Library doesn't include notification channels APIs. As a result some functionalities are available only for specific Android versions. The **minimum Android version** required for `NotificationManager`  to have any effect is **8.0 (API level 26)**.

The following tables show available operations based on the Android SDK version:

- `NotificationManager`

|                                   | API 26 O | API 28 P + |
|-----------------------------------|----------|------------|
| `createNotificationChannel`       | ✅        | ✅          |
| `createNotificationChannels`      | ✅        | ✅          |
| `createNotificationChannelGroup`  | ✅        | ✅          |
| `createNotificationChannelGroups` | ✅        | ✅          |
| `deleteNotificationChannel`       | ✅        | ✅          |
| `createNotificationChannelGroup`  | ✅        | ✅          |
| `getNotificationChannel`          | ✅        | ✅          |
| `getNotificationChannels`         | ✅        | ✅          |
| `getNotificationChannelGroup`     | ❌        | ✅          |
| `getNotificationChannelGroups`    | ✅        | ✅          |

- `NotificationChannel`

|                    | API 26 O | API 28 P | API 29 Q | API 30 R + |
|--------------------|----------|----------|----------|------------|
| `id`               | ✅        | ✅        | ✅        | ✅          |
| `name`             | ✅        | ✅        | ✅        | ✅          |
| `importance`       | ✅        | ✅        | ✅        | ✅          |
| `description`      | ✅        | ✅        | ✅        | ✅          |
| `groupId`          | ✅        | ✅        | ✅        | ✅          |
| `conversation`     | ❌        | ❌        | ❌        | ✅          |
| `showBubble`       | ❌        | ❌        | ✅        | ❌          |
| `showBadge`        | ✅        | ✅        | ✅        | ✅          |
| `enableLights`     | ✅        | ✅        | ✅        | ✅          |
| `lightColor`       | ✅        | ✅        | ✅        | ✅          |
| `enableVibrations` | ✅        | ✅        | ✅        | ✅          |

- `NotificationChannelGroup`

|               | API26 O | API 28 P + |
|---------------|---------|------------|
| `id`          | ✅       | ✅          |
| `name`        | ✅       | ✅          |
| `description` | ❌       | ✅          |

## Error Handling

Calling any of `NotificationManager` methods on API level 25 and below will not have any effect and will also NOT result in any error. The same rule applies to any of the `NotificationChannel` and `NotificationChannelGroup` properties. 

But there are some preconditions when that must be met when creating a `NotificationChannel` and `NotificationChannelGroup`:

- `NotificationChannel`
  - `id` must not be null, empty or blank

- `NotificationChannelGroup`
  - `id` must not be null, empty or blank
  - `importance` must not be `Importance.unspecified`

Breaking any of these will result in `PlatformException` with `INVALID_ARGUMENT` code.

You may also experience a `PlatformException` with `UNKNOWN` code. This exception should not happen and most likely indicates an edge case that has not yet been properly handled.

## Read More

- [Android Developers docs](https://developer.android.com/develop/ui/views/notifications/channels)
- [Android `NotificationManager` docs](https://developer.android.com/reference/android/app/NotificationManager)
- [Android `NotificationChannel` docs](https://developer.android.com/reference/android/app/NotificationChannel)
- [Android `NotificationChannelGroup` docs](https://developer.android.com/reference/android/app/NotificationChannelGroup)
