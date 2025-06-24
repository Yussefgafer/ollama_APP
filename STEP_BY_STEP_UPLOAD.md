# 📤 دليل الرفع خطوة بخطوة

## 🎯 الهدف: رفع التطبيق والحصول على APK خلال 10 دقائق

---

## 🚀 الطريقة الأولى: الرفع التلقائي (الأسرع)

### الخطوة 1: تحضير البيئة
```bash
# افتح PowerShell كـ Administrator
# انتقل لمجلد المشروع
cd "C:\Users\Administrator\Desktop\flutter_ollama_app\ollama_app"
```

### الخطوة 2: تشغيل Script الرفع
```bash
# إذا كان Git مثبت
.\setup-git.bat

# أو استخدم PowerShell
.\auto-upload.ps1
```

### الخطوة 3: انتظار النتيجة
- ✅ سيتم رفع الملفات تلقائياً
- ✅ GitHub Actions ستبدأ البناء
- ✅ APK جاهز خلال 5-10 دقائق

---

## 🌐 الطريقة الثانية: الرفع عبر GitHub Web

### الخطوة 1: تحضير الملفات
1. **اضغط الملفات:**
   - انقر بالزر الأيمن على مجلد المشروع
   - اختر "Send to" → "Compressed folder"
   - أو استخدم: `ollama_app_complete.zip` (موجود بالفعل)

### الخطوة 2: الرفع على GitHub
1. **اذهب إلى:** https://github.com/Yussefgafer/ollama_APP
2. **انقر:** "Add file" → "Upload files"
3. **اسحب:** ملف ZIP أو انقر "choose your files"
4. **اكتب Commit message:**
   ```
   🎉 Complete Ollama Chat App
   
   ✨ Features: Flutter app with GitHub Actions for APK building
   ```
5. **انقر:** "Commit changes"

### الخطوة 3: انتظار البناء
1. **اذهب إلى:** https://github.com/Yussefgafer/ollama_APP/actions
2. **انتظر:** اكتمال البناء (دائرة خضراء ✅)
3. **انقر:** على آخر build
4. **حمل:** "ollama-chat-apk" من Artifacts

---

## 📱 الطريقة الثالثة: GitHub Desktop

### الخطوة 1: تحميل GitHub Desktop
- **حمل من:** https://desktop.github.com/
- **ثبت** وسجل دخول بحسابك

### الخطوة 2: إضافة المشروع
1. **File** → "Add Local Repository"
2. **اختر:** مجلد المشروع
3. **Initialize Git Repository** إذا طُلب منك
4. **Publish Repository** → اختر "ollama_APP"

### الخطوة 3: Commit ورفع
1. **اكتب Summary:** "Complete Ollama Chat App"
2. **انقر:** "Commit to main"
3. **انقر:** "Push origin"

---

## 🔧 إعدادات ما بعد الرفع

### 1. تفعيل GitHub Actions
- **اذهب إلى:** https://github.com/Yussefgafer/ollama_APP/settings/actions
- **تأكد من تفعيل:** "Allow all actions and reusable workflows"

### 2. تفعيل GitHub Pages
- **اذهب إلى:** https://github.com/Yussefgafer/ollama_APP/settings/pages
- **Source:** اختر "GitHub Actions"
- **انقر:** "Save"

### 3. إعدادات Repository
- **تأكد من:** Repository عام (Public)
- **فعل:** Issues و Discussions إذا أردت

---

## 📥 الحصول على APK

### من GitHub Actions (الطريقة الرئيسية):
1. **اذهب إلى:** https://github.com/Yussefgafer/ollama_APP/actions
2. **انقر:** على آخر workflow ناجح (✅)
3. **اذهب إلى:** قسم "Artifacts"
4. **حمل:** "ollama-chat-apk.zip"
5. **استخرج:** ملف APK

### من Releases (للإصدارات):
```bash
# إنشاء tag للإصدار
git tag v1.0.0
git push origin v1.0.0
```
- سيتم إنشاء Release تلقائياً مع APK

---

## 🌐 تطبيق الويب

بعد تفعيل GitHub Pages:
- **الرابط:** https://yussefgafer.github.io/ollama_APP
- **التحديث:** تلقائي مع كل push

---

## ❗ استكشاف الأخطاء

### مشكلة: Git غير مثبت
**الحل:**
1. حمل Git من: https://git-scm.com/download/win
2. ثبت مع الإعدادات الافتراضية
3. أعد تشغيل Command Prompt

### مشكلة: فشل في Push
**الحل:**
1. تأكد من صحة اسم المستخدم والبريد الإلكتروني
2. استخدم Personal Access Token بدلاً من كلمة المرور
3. أو استخدم GitHub Desktop

### مشكلة: GitHub Actions لا تعمل
**الحل:**
1. تأكد من وجود مجلد `.github/workflows/`
2. تحقق من صحة ملفات YAML
3. فعل Actions في إعدادات Repository

### مشكلة: APK لا يبنى
**الحل:**
1. تحقق من logs في GitHub Actions
2. تأكد من صحة ملف `pubspec.yaml`
3. تأكد من وجود ملفات Android

---

## 🎉 النتيجة المتوقعة

### خلال 10 دقائق من الرفع:
- ✅ **Repository** مكتمل على GitHub
- ✅ **APK** جاهز للتحميل
- ✅ **تطبيق ويب** منشور ويعمل
- ✅ **CI/CD** يعمل تلقائياً

### الروابط النهائية:
- **📱 APK:** https://github.com/Yussefgafer/ollama_APP/actions
- **🌐 Web App:** https://yussefgafer.github.io/ollama_APP
- **📦 Releases:** https://github.com/Yussefgafer/ollama_APP/releases
- **⚙️ Settings:** https://github.com/Yussefgafer/ollama_APP/settings

---

## 🆘 الدعم

إذا واجهت أي مشكلة:
1. **تحقق من:** ملف `UPLOAD_INSTRUCTIONS.md`
2. **راجع:** GitHub Actions logs
3. **تأكد من:** إعدادات Repository

**🎯 الهدف: APK جاهز خلال 10 دقائق من بدء الرفع!**
