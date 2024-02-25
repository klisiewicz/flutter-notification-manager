package dev.klisiewicz.flutter_notification_manager.validation

fun String?.checkNotNull(arg: String): String {
    if (this == null) {
        throw IllegalArgumentException("$arg must not be null");
    }
    return this;
}

fun String.checkNotEmptyOrBlank(arg: String): String {
    if (isEmpty() || isBlank()) {
        throw IllegalArgumentException("$arg must not be empty or blank");
    }
    return this;
}

