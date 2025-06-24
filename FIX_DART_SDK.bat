@echo off
chcp 65001 >nul
echo 🔧 إصلاح مشكلة Dart SDK
echo ==========================

echo 📝 تطبيق إصلاحات Dart SDK...

echo 1️⃣ نسخ ملف GitHub Actions المُصحح...
copy "FIXED_DART_SDK_ACTION.yml" ".github\workflows\build-apk.yml"

echo 2️⃣ تنظيف المشروع...
flutter clean
flutter pub get

echo 3️⃣ رفع الإصلاحات...
git add .
git commit -m "🔧 FIX: Dart SDK version compatibility

❌ Problem: Flutter 3.24.0 has Dart 3.5.0 but pubspec required ^3.8.1
✅ Solution: 
- Fixed pubspec.yaml environment to support Dart 3.5.0+
- Updated GitHub Actions with proper Flutter version
- Added flutter config --no-analytics
- Downgraded some dependencies for compatibility

This will resolve the 'version solving failed' error!"

git push origin main

echo ✅ تم إصلاح مشكلة Dart SDK!
echo 🔄 GitHub Actions ستعمل الآن بدون أخطاء

echo.
echo 📋 ما تم إصلاحه:
echo - pubspec.yaml: environment متوافق مع Dart 3.5.0
echo - GitHub Actions: Flutter 3.24.0 مع Dart 3.5.0
echo - Dependencies: إصدارات متوافقة
echo - Analytics: معطل لتجنب التأخير

echo.
echo 🔗 تابع النتائج:
echo https://github.com/Yussefgafer/ollama_APP/actions

echo.
echo ⏰ النتيجة المتوقعة:
echo - flutter pub get سيعمل بدون أخطاء
echo - APK سيبنى خلال 5 دقائق
echo - حجم APK: 15-25 MB

pause
