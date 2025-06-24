@echo off
chcp 65001 >nul
echo 🚀 رفع تطبيق Ollama Chat على GitHub
echo =====================================

REM التحقق من وجود Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git غير مثبت!
    echo 📥 يرجى تحميل Git من: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo ✅ Git موجود
echo 📁 تهيئة Git repository...
git init

REM إعداد Git config إذا لم يكن موجود
for /f "tokens=*" %%i in ('git config user.name 2^>nul') do set USERNAME=%%i
if "%USERNAME%"=="" (
    set /p USERNAME="أدخل اسمك للـ Git: "
    git config user.name "%USERNAME%"
)

for /f "tokens=*" %%i in ('git config user.email 2^>nul') do set USEREMAIL=%%i
if "%USEREMAIL%"=="" (
    set /p USEREMAIL="أدخل بريدك الإلكتروني للـ Git: "
    git config user.email "%USEREMAIL%"
)

echo 📝 إضافة جميع الملفات...
git add .

echo 💾 إنشاء Commit...
git commit -m "🎉 Initial commit: Complete Ollama Chat App

✨ Features:
- Complete Flutter app with Material Design 3
- GitHub Actions for automatic APK building
- Web deployment to GitHub Pages
- Arabic language support (RTL)
- Ollama API integration
- Local database with Hive
- Modern UI/UX with animations
- Provider state management
- Comprehensive error handling

🚀 Ready for production use!"

echo 🌐 ربط بـ GitHub repository...
git remote add origin https://github.com/Yussefgafer/ollama_APP.git

echo 📤 رفع الملفات إلى GitHub...
git branch -M main
git push -u origin main

if errorlevel 1 (
    echo ⚠️ قد تحتاج لتسجيل الدخول إلى GitHub
    echo 🔑 استخدم GitHub Desktop أو Personal Access Token
) else (
    echo ✅ تم رفع الملفات بنجاح!
)

echo ✅ تم الانتهاء!
echo 🔗 Repository URL: https://github.com/Yussefgafer/ollama_APP
echo 📱 سيتم بناء APK تلقائياً في GitHub Actions
echo 🌐 سيتم نشر تطبيق الويب على GitHub Pages

echo.
echo 📋 الخطوات التالية:
echo 1. اذهب إلى https://github.com/Yussefgafer/ollama_APP
echo 2. انتقل إلى تبويب Actions
echo 3. شاهد عملية البناء (5-10 دقائق)
echo 4. حمل APK من Artifacts
echo 5. فعل GitHub Pages في Settings → Pages

echo.
echo 🎯 روابط مهمة:
echo - Repository: https://github.com/Yussefgafer/ollama_APP
echo - Actions: https://github.com/Yussefgafer/ollama_APP/actions
echo - Releases: https://github.com/Yussefgafer/ollama_APP/releases
echo - Web App: https://yussefgafer.github.io/ollama_APP

pause
