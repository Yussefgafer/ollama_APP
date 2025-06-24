# 📤 تعليمات رفع الملفات على GitHub

## 🚀 خطوات الرفع:

### الطريقة الأولى: استخدام Git Command Line

#### 1. تثبيت Git (إذا لم يكن مثبتاً):
- حمل Git من: https://git-scm.com/download/win
- ثبته مع الإعدادات الافتراضية

#### 2. فتح Command Prompt أو PowerShell:
```bash
# الانتقال لمجلد المشروع
cd C:\Users\Administrator\Desktop\flutter_ollama_app\ollama_app

# تشغيل script الرفع
setup-git.bat
```

### الطريقة الثانية: رفع يدوي

#### 1. تهيئة Git:
```bash
git init
git add .
git commit -m "🎉 Initial commit: Ollama Chat App"
```

#### 2. ربط بالـ Repository:
```bash
git remote add origin https://github.com/Yussefgafer/ollama_APP.git
git branch -M main
git push -u origin main
```

### الطريقة الثالثة: استخدام GitHub Desktop

#### 1. تحميل GitHub Desktop:
- حمل من: https://desktop.github.com/
- سجل دخول بحسابك

#### 2. إضافة المشروع:
- File → Add Local Repository
- اختر مجلد المشروع
- Publish Repository

## 🔧 إعدادات مطلوبة بعد الرفع:

### 1. تفعيل GitHub Actions:
- اذهب إلى: https://github.com/Yussefgafer/ollama_APP/settings/actions
- تأكد من تفعيل Actions

### 2. تفعيل GitHub Pages:
- اذهب إلى: https://github.com/Yussefgafer/ollama_APP/settings/pages
- Source: اختر "GitHub Actions"
- Save

### 3. إعدادات Repository:
- اذهب إلى: https://github.com/Yussefgafer/ollama_APP/settings
- تأكد من أن Repository عام (Public)

## 📱 الحصول على APK:

### من GitHub Actions:
1. اذهب إلى: https://github.com/Yussefgafer/ollama_APP/actions
2. انتظر اكتمال البناء (5-10 دقائق)
3. انقر على آخر build ناجح
4. حمل "ollama-chat-apk" من Artifacts

### إنشاء Release:
```bash
git tag v1.0.0
git push origin v1.0.0
```
- سيتم إنشاء Release تلقائياً مع APK

## 🌐 تطبيق الويب:

بعد تفعيل GitHub Pages، سيكون التطبيق متاحاً على:
**https://yussefgafer.github.io/ollama_APP**

## 🔗 روابط مهمة:

- **Repository**: https://github.com/Yussefgafer/ollama_APP
- **Actions**: https://github.com/Yussefgafer/ollama_APP/actions
- **Releases**: https://github.com/Yussefgafer/ollama_APP/releases
- **Settings**: https://github.com/Yussefgafer/ollama_APP/settings
- **Web App**: https://yussefgafer.github.io/ollama_APP

## ❗ ملاحظات مهمة:

1. **تأكد من تثبيت Git** قبل تشغيل الأوامر
2. **انتظر اكتمال البناء** في GitHub Actions
3. **فعل GitHub Pages** لتطبيق الويب
4. **APK سيكون جاهزاً** خلال 5-10 دقائق من الرفع

## 🆘 في حالة المشاكل:

### مشكلة Git غير مثبت:
- حمل وثبت Git من الرابط أعلاه
- أعد تشغيل Command Prompt

### مشكلة في الرفع:
- تأكد من صحة رابط Repository
- تأكد من صلاحيات الكتابة

### مشكلة في GitHub Actions:
- تحقق من ملفات `.github/workflows/`
- تأكد من تفعيل Actions في الإعدادات

---

**🎉 بالتوفيق! تطبيقك سيكون جاهزاً قريباً**
