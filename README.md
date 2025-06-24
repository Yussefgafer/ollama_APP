# 🤖 Ollama Chat - تطبيق Flutter احترافي ومتقدم

تطبيق Flutter احترافي ومتقدم للتفاعل مع Ollama API مع التركيز على تجربة المستخدم المتميزة والواجهة الحديثة.

## ✨ المميزات الرئيسية

### 🔌 تكامل Ollama API
- ✅ دعم كامل لـ Ollama REST API
- ✅ Streaming chat مع تحديث فوري للرسائل
- ✅ إدارة النماذج (list, pull, delete, show)
- ✅ دعم النماذج متعددة الوسائط (Vision Models)
- ✅ معالجة الأخطاء والاستثناءات بذكاء
- ✅ إعادة الاتصال التلقائي عند انقطاع الشبكة
- ✅ Cache للاستجابات لتحسين الأداء

### 💬 نظام المحادثة المتقدم
- ✅ محادثات متعددة مع تبويبات
- ✅ تاريخ المحادثات مع البحث
- ✅ تصدير/استيراد المحادثات (JSON, Markdown, PDF)
- ✅ مشاركة المحادثات عبر الروابط
- ✅ نسخ احتياطي تلقائي للسحابة
- ✅ ضغط الرسائل الطويلة مع إمكانية التوسيع
- ✅ تجميع الرسائل حسب التاريخ
- ✅ إشارات مرجعية للرسائل المهمة

### 🎨 تصميم UI/UX متقدم
- ✅ Material Design 3 مع ألوان ديناميكية
- ✅ Dark/Light mode مع تبديل سلس
- ✅ ثيمات متعددة قابلة للتخصيص
- ✅ أنيميشن سلسة ومتقنة
- ✅ تخطيط تكيفي (Responsive) للشاشات المختلفة
- ✅ دعم RTL للغة العربية
- ✅ إيماءات متقدمة (swipe, long press, pinch to zoom)
- ✅ تأثيرات بصرية جذابة (parallax, blur, gradient)

## 🚀 التشغيل والتطوير

### المتطلبات
- Flutter SDK 3.8.1+
- Dart 3.0+
- Android Studio / VS Code
- خادم Ollama يعمل

### خطوات التشغيل

1. **تثبيت التبعيات:**
```bash
flutter pub get
```

2. **تشغيل مولدات الكود:**
```bash
flutter packages pub run build_runner build
```

3. **تشغيل التطبيق:**
```bash
flutter run
```

### إعداد Ollama

1. **تثبيت Ollama:**
```bash
# على macOS
brew install ollama

# على Linux
curl -fsSL https://ollama.ai/install.sh | sh
```

2. **تشغيل خادم Ollama:**
```bash
ollama serve
```

3. **تحميل نموذج:**
```bash
ollama pull llama2
```

## 🎯 الاستخدام

### الاتصال بـ Ollama
1. افتح التطبيق
2. اذهب إلى الإعدادات
3. أدخل رابط خادم Ollama (افتراضي: `http://localhost:11434`)
4. اختبر الاتصال

### إنشاء محادثة جديدة
1. اضغط على زر "محادثة جديدة"
2. اختر النموذج المطلوب
3. ابدأ الكتابة والمحادثة

## 🚀 GitHub Actions - البناء التلقائي

### 📱 بناء APK تلقائياً
يتم بناء APK تلقائياً عند كل push أو pull request باستخدام GitHub Actions:

1. **انتقل إلى تبويب Actions في GitHub**
2. **شاهد عملية البناء الجارية**
3. **حمل APK من Artifacts بعد اكتمال البناء**

### 🌐 نشر تطبيق الويب
- يتم نشر تطبيق الويب تلقائياً على GitHub Pages
- الرابط: `https://your-username.github.io/ollama-chat-app`

### 🎉 إصدارات تلقائية
عند إنشاء tag جديد (مثل `v1.0.0`):
- يتم بناء APK للجميع المعماريات
- يتم بناء تطبيق الويب
- يتم إنشاء Release تلقائياً مع الملفات

```bash
# إنشاء إصدار جديد
git tag v1.0.0
git push origin v1.0.0
```

## 📦 التحميل

### من GitHub Releases
1. اذهب إلى [Releases](https://github.com/Yussefgafer/ollama_APP/releases)
2. حمل أحدث APK
3. ثبت على جهازك

### من GitHub Actions
1. اذهب إلى [Actions](https://github.com/Yussefgafer/ollama_APP/actions)
2. اختر آخر build ناجح
3. حمل APK من Artifacts

---

**صنع بـ ❤️ باستخدام Flutter**
