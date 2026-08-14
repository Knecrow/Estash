# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core deferred components (optional in standard Flutter apps)
-dontwarn com.google.android.play.core.**

# Keep Home Widget classes
-keep class es.antonborri.home_widget.** { *; }
-keep class com.estash.estash.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Desugaring & General
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-dontwarn java.time.**
-dontwarn javax.annotation.**
