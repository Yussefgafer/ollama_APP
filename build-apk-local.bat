@echo off
chcp 65001 >nul
echo 🚀 بناء APK محلياً - حل مشكلة NDK
echo =====================================

echo 🔧 حل مشكلة NDK...
echo 1. حذف NDK المعطوب...
if exist "C:\Users\Administrator\AppData\Local\Android\sdk\ndk\27.0.12077973" (
    rmdir /s /q "C:\Users\Administrator\AppData\Local\Android\sdk\ndk\27.0.12077973"
    echo ✅ تم حذف NDK المعطوب
) else (
    echo ℹ️ NDK غير موجود
)

echo 2. حذف مجلد NDK بالكامل...
if exist "C:\Users\Administrator\AppData\Local\Android\sdk\ndk" (
    rmdir /s /q "C:\Users\Administrator\AppData\Local\Android\sdk\ndk"
    echo ✅ تم حذف مجلد NDK
)

echo 🧹 تنظيف المشروع...
flutter clean

echo 📦 تحديث Dependencies...
flutter pub get

echo 🔨 محاولة بناء APK بدون NDK...
flutter build apk --release --no-tree-shake-icons

if errorlevel 1 (
    echo ❌ فشل البناء مع NDK
    echo 🔄 محاولة بناء Web بدلاً من APK...
    flutter build web --release
    
    if errorlevel 1 (
        echo ❌ فشل بناء Web أيضاً
        echo 🆘 جرب الحلول التالية:
        echo 1. تحديث Android SDK من Android Studio
        echo 2. إعادة تثبيت Flutter
        echo 3. استخدام GitHub Actions للبناء
    ) else (
        echo ✅ تم بناء تطبيق الويب بنجاح!
        echo 📁 الملفات في: build\web\
        echo 🌐 يمكن نشرها على أي خادم ويب
    )
) else (
    echo ✅ تم بناء APK بنجاح!
    echo 📱 ملف APK في: build\app\outputs\flutter-apk\
    dir "build\app\outputs\flutter-apk\*.apk"
)

echo.
echo 📋 ملخص النتائج:
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK جاهز: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo ❌ APK غير متوفر
)

if exist "build\web\index.html" (
    echo ✅ تطبيق الويب جاهز: build\web\
) else (
    echo ❌ تطبيق الويب غير متوفر
)

echo.
echo 🔗 البدائل المتاحة:
echo 1. GitHub Actions: https://github.com/Yussefgafer/ollama_APP/actions
echo 2. تطبيق الويب: https://yussefgafer.github.io/ollama_APP
echo 3. تحميل Android Studio وإصلاح SDK

pause
