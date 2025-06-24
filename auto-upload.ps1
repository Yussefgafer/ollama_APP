# 🚀 Script تلقائي لرفع تطبيق Ollama Chat على GitHub
# PowerShell Script for automatic upload

Write-Host "🚀 بدء رفع تطبيق Ollama Chat على GitHub" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan

# التحقق من وجود Git
try {
    $gitVersion = git --version
    Write-Host "✅ Git موجود: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git غير مثبت!" -ForegroundColor Red
    Write-Host "📥 يرجى تحميل Git من: https://git-scm.com/download/win" -ForegroundColor Yellow
    Read-Host "اضغط Enter للخروج"
    exit
}

# تهيئة Git repository
Write-Host "📁 تهيئة Git repository..." -ForegroundColor Yellow
git init

# إعداد Git config إذا لم يكن موجود
$userName = git config user.name
if (-not $userName) {
    $name = Read-Host "أدخل اسمك للـ Git"
    git config user.name "$name"
}

$userEmail = git config user.email
if (-not $userEmail) {
    $email = Read-Host "أدخل بريدك الإلكتروني للـ Git"
    git config user.email "$email"
}

# إضافة جميع الملفات
Write-Host "📝 إضافة جميع الملفات..." -ForegroundColor Yellow
git add .

# Commit
Write-Host "💾 إنشاء Commit..." -ForegroundColor Yellow
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

# إضافة remote origin
Write-Host "🌐 ربط بـ GitHub repository..." -ForegroundColor Yellow
git remote add origin https://github.com/Yussefgafer/ollama_APP.git

# Push إلى GitHub
Write-Host "📤 رفع الملفات إلى GitHub..." -ForegroundColor Yellow
git branch -M main

try {
    git push -u origin main
    Write-Host "✅ تم رفع الملفات بنجاح!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ قد تحتاج لتسجيل الدخول إلى GitHub" -ForegroundColor Yellow
    Write-Host "🔑 استخدم GitHub Desktop أو Personal Access Token" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎉 تم الانتهاء من الرفع!" -ForegroundColor Green
Write-Host "🔗 Repository: https://github.com/Yussefgafer/ollama_APP" -ForegroundColor Cyan
Write-Host "📱 APK سيكون جاهز في: https://github.com/Yussefgafer/ollama_APP/actions" -ForegroundColor Cyan
Write-Host "🌐 تطبيق الويب: https://yussefgafer.github.io/ollama_APP" -ForegroundColor Cyan

Write-Host ""
Write-Host "📋 الخطوات التالية:" -ForegroundColor Yellow
Write-Host "1. اذهب إلى GitHub Actions وانتظر اكتمال البناء" -ForegroundColor White
Write-Host "2. حمل APK من Artifacts" -ForegroundColor White  
Write-Host "3. فعل GitHub Pages في Settings" -ForegroundColor White

Read-Host "اضغط Enter للخروج"
