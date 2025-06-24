@echo off
chcp 65001 >nul
echo 🚨 إصلاح طارئ لمشاكل GitHub Actions
echo =====================================

echo 🔧 تطبيق الإصلاحات الطارئة...

echo 1️⃣ إصلاح ملف GitHub Actions...
copy "WORKING_GITHUB_ACTION.yml" ".github\workflows\build-apk.yml"

echo 2️⃣ إنشاء ملف احتياطي مبسط...
copy "MINIMAL_GITHUB_ACTION.yml" ".github\workflows\simple-build.yml"

echo 3️⃣ تنظيف المشروع...
flutter clean
flutter pub get

echo 4️⃣ رفع الإصلاحات إلى GitHub...
git add .
git commit -m "🚨 EMERGENCY FIX: Simplified GitHub Actions

- Fixed Flutter version to stable 3.19.6
- Fixed Java version to 11
- Simplified workflow structure
- Removed problematic dependencies
- Fixed pubspec.yaml environment
- Added minimal backup workflow

This should resolve all build issues!"

git push origin main

echo ✅ تم تطبيق الإصلاحات الطارئة!
echo 🔄 GitHub Actions ستعمل الآن بشكل صحيح

echo.
echo 📋 تحقق من النتائج:
echo 1. اذهب إلى: https://github.com/Yussefgafer/ollama_APP/actions
echo 2. انتظر اكتمال البناء (3-5 دقائق)
echo 3. حمل APK من Artifacts

echo.
echo 🆘 إذا لم تعمل:
echo 1. شغل "simple-build" workflow يدوياً
echo 2. تحقق من logs للأخطاء
echo 3. استخدم تطبيق الويب كبديل

pause
