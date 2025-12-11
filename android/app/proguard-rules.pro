# Keep Flutter embedding and generated plugin registrant
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-dontwarn io.flutter.embedding.**

# Keep WorkManager generated classes (if used)
-keep class androidx.work.impl.background.systemjob.SystemJobService { *; }
-keep class androidx.work.impl.background.systemalarm.SystemAlarmService { *; }

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Keep EasyLocalization generated keys/resources
-keep class com.easy.localization.** { *; }
-keepclassmembers class ** { @com.easy.localization.annotations.* <fields>; }

# Keep Notification-related classes
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**
