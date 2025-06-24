# 🚀 دليل البدء السريع

## 📱 الحصول على APK

### الطريقة الأولى: GitHub Actions (مُوصى بها)
1. **إنشاء GitHub Repository:**
   ```bash
   # تشغيل script الإعداد
   setup-git.bat
   ```

2. **انتظار البناء:**
   - اذهب إلى `https://github.com/YOUR_USERNAME/ollama-chat-app/actions`
   - انتظر اكتمال البناء (5-10 دقائق)
   - حمل APK من Artifacts

3. **تحميل APK:**
   - انقر على آخر build ناجح
   - اذهب إلى قسم Artifacts
   - حمل `ollama-chat-apk.zip`
   - استخرج ملف APK

### الطريقة الثانية: GitHub Releases
1. **إنشاء Release:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **تحميل من Releases:**
   - اذهب إلى `https://github.com/YOUR_USERNAME/ollama-chat-app/releases`
   - حمل أحدث APK

## 🌐 تطبيق الويب

### نشر على GitHub Pages
1. **تفعيل GitHub Pages:**
   - اذهب إلى Settings في repository
   - انتقل إلى Pages
   - اختر "GitHub Actions" كمصدر

2. **الوصول للتطبيق:**
   - الرابط: `https://YOUR_USERNAME.github.io/ollama-chat-app`

## 🛠 التطوير المحلي

### التثبيت
```bash
# استنساخ المشروع
git clone https://github.com/YOUR_USERNAME/ollama-chat-app.git
cd ollama-chat-app

# تثبيت التبعيات
flutter pub get

# تشغيل مولدات الكود
flutter packages pub run build_runner build

# تشغيل التطبيق
flutter run
```

### البناء المحلي
```bash
# بناء APK
flutter build apk --release

# بناء تطبيق الويب
flutter build web --release
```

## 🔧 إعداد Ollama

### تثبيت Ollama
```bash
# Windows (PowerShell)
winget install Ollama.Ollama

# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.ai/install.sh | sh
```

### تشغيل Ollama
```bash
# تشغيل الخادم
ollama serve

# تحميل نموذج
ollama pull llama2
ollama pull codellama
```

### إعداد التطبيق
1. افتح التطبيق
2. اذهب إلى الإعدادات ⚙️
3. أدخل رابط Ollama: `http://localhost:11434`
4. اختبر الاتصال
5. ابدأ المحادثة! 🎉

## 📋 استكشاف الأخطاء

### مشاكل شائعة

#### لا يمكن الاتصال بـ Ollama
```bash
# تأكد من تشغيل Ollama
ollama serve

# تحقق من المنفذ
netstat -an | findstr 11434
```

#### مشاكل في البناء
```bash
# تنظيف المشروع
flutter clean
flutter pub get

# إعادة تشغيل مولدات الكود
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

#### مشاكل GitHub Actions
- تأكد من صحة ملفات `.github/workflows/`
- تحقق من logs في تبويب Actions
- تأكد من تفعيل Actions في repository

## 🎯 نصائح مفيدة

### تحسين الأداء
- استخدم نماذج أصغر للاختبار (llama2:7b)
- فعل GPU acceleration إن أمكن
- أغلق التطبيقات الأخرى أثناء الاستخدام

### الأمان
- لا تشارك API keys في الكود
- استخدم HTTPS للاتصالات الخارجية
- فعل التشفير للبيانات الحساسة

### التخصيص
- غير الثيمات من الإعدادات
- اختر النماذج المفضلة
- خصص اختصارات لوحة المفاتيح

---

**🎉 مبروك! تطبيقك جاهز للاستخدام**

للمساعدة أو الأسئلة، افتح Issue في GitHub أو راسلنا مباشرة.
