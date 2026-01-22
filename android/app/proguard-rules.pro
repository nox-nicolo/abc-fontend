# Preserve OkHttp3 classes used by ucrop/image_picker
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Often needed alongside OkHttp
-keep class okio.** { *; }
-dontwarn okio.**