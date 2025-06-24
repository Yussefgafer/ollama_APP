@echo off
echo 🚀 بناء تطبيق Ollama Chat APK
echo ================================

echo 🧹 تنظيف المشروع...
flutter clean

echo 📦 تحديث Dependencies...
flutter pub get

echo 🔨 بناء APK...
flutter build apk --release

echo ✅ تم الانتهاء!
echo 📱 ملف APK موجود في: build\app\outputs\flutter-apk\app-release.apk

pause
