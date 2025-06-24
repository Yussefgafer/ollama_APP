@echo off
chcp 65001 >nul
echo 🔧 رفع إصلاحات GitHub Actions
echo ===============================

echo 📝 إضافة الملفات المحدثة...
git add .github/workflows/
git add fix-github-actions.md
git add github-actions-fixed.yml

echo 💾 إنشاء commit...
git commit -m "🔧 Fix GitHub Actions configuration

✅ Fixed Issues:
- Updated Flutter version to stable 3.24.0
- Changed Java distribution to temurin
- Made build_runner optional with error handling
- Added verbose logging for debugging
- Simplified workflow structure
- Added APK verification step
- Improved error handling with continue-on-error

🚀 This should resolve build failures and generate APK successfully"

echo 📤 رفع التحديثات...
git push origin main

if errorlevel 1 (
    echo ❌ فشل في الرفع
    echo 🔑 تأكد من تسجيل الدخول إلى GitHub
) else (
    echo ✅ تم رفع الإصلاحات بنجاح!
    echo 🔄 GitHub Actions ستبدأ تلقائياً
    echo 🌐 تابع التقدم على: https://github.com/Yussefgafer/ollama_APP/actions
)

echo.
echo 📋 الخطوات التالية:
echo 1. اذهب إلى GitHub Actions
echo 2. تحقق من آخر workflow
echo 3. إذا فشل، شغل "Simple APK Build" يدوياً
echo 4. حمل APK من Artifacts عند النجاح

pause
