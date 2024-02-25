package dev.klisiewicz.flutter_notification_manager.group

import android.annotation.TargetApi
import android.app.NotificationChannelGroup
import android.os.Build
import dev.klisiewicz.flutter_notification_manager.validation.checkNotEmptyOrBlank
import dev.klisiewicz.flutter_notification_manager.validation.checkNotNull

@TargetApi(Build.VERSION_CODES.O)
internal fun NotificationChannelGroup.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "description" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            description
        } else null,
    )
}

@TargetApi(Build.VERSION_CODES.O)
internal fun Map<String, Any?>.toNotificationChannelGroup(): NotificationChannelGroup {
    val id = (get("id") as String?).checkNotNull("id").checkNotEmptyOrBlank("id")
    val name = get("name") as String?
    val description = get("description") as String?
    return NotificationChannelGroup(id, name).apply {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) this.description = description
    }
}
