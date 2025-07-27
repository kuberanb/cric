

# Keep only the default Latin text recognizer
-keep class com.google.mlkit.vision.text.TextRecognizer { *; }

# Ignore warnings about missing language-specific recognizers
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
