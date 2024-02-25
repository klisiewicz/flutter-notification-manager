package dev.klisiewicz.flutter_notification_manager.channel

import android.annotation.TargetApi
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import dev.klisiewicz.flutter_notification_manager.validation.checkNotEmptyOrBlank
import dev.klisiewicz.flutter_notification_manager.validation.checkNotNull

@TargetApi(Build.VERSION_CODES.O)
internal fun NotificationChannel.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "importance" to importance,
        "description" to description,
        "groupId" to group,
        "conversation" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && conversationId != null && parentChannelId != null) {
            mapOf(
                "conversationId" to conversationId,
                "parentChannelId" to parentChannelId,
            )
        } else null,
        "showBubble" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            canBubble()
        } else false,
        "showBadge" to canShowBadge(),
        "enableLights" to shouldShowLights(),
        "lightColor" to lightColor,
        "enableVibrations" to shouldVibrate(),
    )
}

@TargetApi(Build.VERSION_CODES.O)
internal fun Map<*, *>.toNotificationChannel(): NotificationChannel {
    val id = (get("id") as String?).checkNotNull("id").checkNotEmptyOrBlank("id")
    val name = get("name") as String?
    val importance = get("importance") as Int? ?: NotificationManager.IMPORTANCE_DEFAULT
    val description = get("description") as String?
    val groupId = get("groupId") as String?
    val showBubble = get("showBubble") as Boolean? ?: false
    val showBadge = get("showBadge") as Boolean? ?: false
    val enableVibrations = get("enableVibrations") as Boolean? ?: false
    val enableLights = get("enableLights") as Boolean? ?: false
    val lightColor = (get("lightColor") as Long? ?: 0).toInt()
    val conversation = get("conversation") as Map<*, *>?
    val parentChannelId = conversation?.get("parentChannelId") as String?
    val conversationId = conversation?.get("conversationId") as String?

    return NotificationChannel(id, name, importance).apply {
        this.group = groupId
        this.description = description
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) setAllowBubbles(showBubble)
        setShowBadge(showBadge)
        enableVibration(enableVibrations)
        enableLights(enableLights)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && conversation != null && conversationId != null && parentChannelId != null) {
            setConversationId(parentChannelId, conversationId)
        }
        this.lightColor = lightColor
    }
}
