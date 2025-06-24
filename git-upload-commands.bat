@echo off
chcp 65001 >nul
echo 🚀 رفع مشروع Ollama Chat على GitHub
echo ========================================

REM التحقق من وجود Git
echo 🔍 التحقق من Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git غير مثبت!
    echo 📥 حمل Git من: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo ✅ Git موجود

REM الانتقال لمجلد المشروع
echo 📁 الانتقال لمجلد المشروع...
cd /d "C:\Users\Administrator\Desktop\flutter_ollama_app\ollama_app"

REM تهيئة Git repository
echo 🔧 تهيئة Git repository...
git init

REM إعداد معلومات المستخدم
echo 👤 إعداد معلومات المستخدم...
git config user.name "Yussefgafer"
git config user.email "yussefgafer@example.com"

REM إضافة جميع الملفات
echo 📝 إضافة جميع الملفات...
git add .

REM عرض حالة الملفات
echo 📊 حالة الملفات:
git status --short

REM إنشاء commit
echo 💾 إنشاء commit...
git commit -m "🎉 Initial commit: Complete Ollama Chat App

✨ Features:
- Complete Flutter app with Material Design 3
- GitHub Actions for automatic APK building
- Web deployment to GitHub Pages
- Arabic language support (RTL)
- Ollama API integration with real-time chat
- Local database with Hive for data persistence
- Modern UI/UX with smooth animations
- Provider state management
- Comprehensive error handling
- Dark/Light theme support
- Responsive design for all screen sizes

🚀 Ready for production use!

📱 APK will be automatically built via GitHub Actions
🌐 Web app will be deployed to GitHub Pages
🔧 CI/CD pipeline fully configured

🏗️ Architecture:
- Clean Architecture with separation of concerns
- Repository pattern for data management
- Dependency injection with Provider
- Reactive programming with Streams
- Error boundary implementation
- Performance optimizations

🎨 UI/UX:
- Material Design 3 components
- Adaptive layouts for different screen sizes
- Smooth page transitions and micro-interactions
- Accessibility support (screen readers, high contrast)
- Internationalization ready (Arabic/English)

🔧 Technical Stack:
- Flutter 3.32.4
- Dart 3.8.1
- Provider for state management
- Hive for local storage
- Dio for HTTP requests
- Material Design 3
- GitHub Actions for CI/CD"

REM إضافة remote origin
echo 🌐 ربط بـ GitHub repository...
git remote add origin https://github.com/Yussefgafer/ollama_APP.git

REM التحقق من remote
echo 🔗 التحقق من remote:
git remote -v

REM تحديد الفرع الرئيسي
echo 🌿 تحديد الفرع الرئيسي...
git branch -M main

REM رفع الملفات
echo 📤 رفع الملفات إلى GitHub...
echo ⚠️ قد تحتاج لإدخال اسم المستخدم وكلمة المرور/Token
git push -u origin main

if errorlevel 1 (
    echo ❌ فشل في الرفع!
    echo 🔑 تأكد من:
    echo    - صحة اسم المستخدم وكلمة المرور
    echo    - استخدام Personal Access Token بدلاً من كلمة المرور
    echo    - الاتصال بالإنترنت
    echo.
    echo 🔗 لإنشاء Personal Access Token:
    echo    https://github.com/settings/tokens
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ تم رفع المشروع بنجاح!
echo 🎉 المشروع متاح الآن على GitHub

echo.
echo 🔗 روابط مهمة:
echo 📁 Repository: https://github.com/Yussefgafer/ollama_APP
echo 🔄 Actions: https://github.com/Yussefgafer/ollama_APP/actions
echo ⚙️ Settings: https://github.com/Yussefgafer/ollama_APP/settings
echo 🌐 Web App: https://yussefgafer.github.io/ollama_APP

echo.
echo 📋 الخطوات التالية:
echo 1. اذهب إلى GitHub Actions وانتظر اكتمال البناء (5-10 دقائق)
echo 2. حمل APK من Artifacts
echo 3. فعل GitHub Pages في Settings → Pages
echo 4. اختر "GitHub Actions" كمصدر للـ Pages

echo.
echo ⏰ النتائج المتوقعة:
echo - APK جاهز خلال 5-10 دقائق
echo - تطبيق الويب جاهز خلال 3-5 دقائق
echo - Repository مكتمل مع توثيق شامل

pause
