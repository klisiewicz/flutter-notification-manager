package dev.klisiewicz.flutter_notification_manager

import android.annotation.TargetApi
import android.app.NotificationManager
import android.content.Context.NOTIFICATION_SERVICE
import android.os.Build.*
import android.util.Log
import dev.klisiewicz.flutter_notification_manager.channel.*
import dev.klisiewicz.flutter_notification_manager.group.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterNotificationManagerPlugin */
class FlutterNotificationManagerPlugin : FlutterPlugin, MethodCallHandler {
    private companion object {
        const val TAG = "FlutterNotificationManagerPlugin"
    }

    private lateinit var channel: MethodChannel
    private lateinit var notificationManager: NotificationManager

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        notificationManager =
            flutterPluginBinding.applicationContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_notification_manager")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.i(TAG, "${call.method}: ${call.arguments}");
        if (VERSION.SDK_INT < VERSION_CODES.O) {
            result.success(null)
            return
        }

        try {
            when (call.method) {
                "createNotificationChannel" -> {
                    createNotificationChannel(call)
                    result.success(null)
                }

                "createNotificationChannelGroup" -> {
                    createNotificationChannelGroup(call)
                    result.success(null)
                }

                "createNotificationChannelGroups" -> {
                    createNotificationChannelGroups(call)
                    result.success(null)
                }

                "createNotificationChannels" -> {
                    createNotificationChannels(call)
                    result.success(null)
                }

                "deleteNotificationChannel" -> {
                    deleteNotificationChannel(call)
                    result.success(null)
                }

                "deleteNotificationChannelGroup" -> {
                    deleteNotificationChannelGroup(call)
                    result.success(null)
                }

                "getNotificationChannel" -> {
                    result.success(getNotificationChannel(call))
                }

                "getNotificationChannelGroup" -> {
                    if (VERSION.SDK_INT >= VERSION_CODES.P) {
                        result.success(getNotificationChannelGroup(call))
                    } else {
                        result.success(null)
                    }
                }

                "getNotificationChannelGroups" -> {
                    result.success(getNotificationChannelGroups(call))
                }

                "getNotificationChannels" -> {
                    result.success(getNotificationChannels(call))
                }

                else -> result.notImplemented()
            }
        } catch (e: IllegalArgumentException) {
            Log.e(TAG, e.message, e);
            result.error("INVALID_ARGUMENT", e.message, call.arguments)
        }catch (e: Exception) {
            Log.e(TAG, e.message, e);
            result.error("UNKNOWN", e.message, call.arguments)
        }
    }

    @TargetApi(VERSION_CODES.O)
    private fun createNotificationChannel(call: MethodCall) {
        val channelMap: Map<String, Any?> = call.argument("channel") ?: emptyMap()
        val channel = channelMap.toNotificationChannel()
        notificationManager.createNotificationChannel(channel)
    }

    @TargetApi(VERSION_CODES.O)
    private fun createNotificationChannelGroup(call: MethodCall) {
        val groupMap: Map<String, Any?> = call.argument("group") ?: emptyMap()
        val group = groupMap.toNotificationChannelGroup()
        notificationManager.createNotificationChannelGroup(group)
    }

    @TargetApi(VERSION_CODES.O)
    private fun createNotificationChannelGroups(call: MethodCall) {
        val groupsMap: List<Map<String, Any?>> = call.argument("groups") ?: emptyList()
        val groups = groupsMap.map { group -> group.toNotificationChannelGroup() }
        notificationManager.createNotificationChannelGroups(groups)
    }

    @TargetApi(VERSION_CODES.O)
    private fun createNotificationChannels(call: MethodCall) {
        val channelsMap: List<Map<String, Any?>> = call.argument("channels") ?: emptyList()
        val channels = channelsMap.map { channel -> channel.toNotificationChannel() }
        notificationManager.createNotificationChannels(channels)
    }

    @TargetApi(VERSION_CODES.O)
    private fun deleteNotificationChannel(call: MethodCall) {
        val channelId = call.argument<String>("channelId")
        notificationManager.deleteNotificationChannel(channelId)
    }

    @TargetApi(VERSION_CODES.O)
    private fun deleteNotificationChannelGroup(call: MethodCall) {
        val groupId = call.argument<String>("groupId")
        notificationManager.deleteNotificationChannelGroup(groupId)
    }

    @TargetApi(VERSION_CODES.O)
    private fun getNotificationChannel(call: MethodCall): Map<String, Any?>? {
        val channelId = call.argument<String>("channelId")
        val channel = notificationManager.getNotificationChannel(channelId)
        return channel?.toMap()
    }

    @TargetApi(VERSION_CODES.P)
    private fun getNotificationChannelGroup(call: MethodCall): Map<String, Any?>? {
        val groupId = call.argument<String>("groupId")
        val group = notificationManager.getNotificationChannelGroup(groupId)
        return group?.toMap()
    }

    @TargetApi(VERSION_CODES.O)
    private fun getNotificationChannelGroups(call: MethodCall): List<Map<String, Any?>> {
        return notificationManager.notificationChannelGroups.map { group -> group.toMap() }
    }

    @TargetApi(VERSION_CODES.O)
    private fun getNotificationChannels(call: MethodCall): List<Map<String, Any?>> {
        return notificationManager.notificationChannels.map { channel -> channel.toMap() }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
