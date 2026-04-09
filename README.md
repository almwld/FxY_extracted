# Flex Yemen - فليكس اليمن

<p align="center">
  <img src="assets/images/logo.png" width="150" alt="Flex Yemen Logo">
</p>

<p align="center">
  <strong>السوق الإلكتروني والمحفظة الرقمية اليمنية</strong>
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Flutter-3.22.0-blue.svg" alt="Flutter"></a>
  <a href="#"><img src="https://img.shields.io/badge/Dart-3.4.0-blue.svg" alt="Dart"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
</p>

---

## 📱 نظرة عامة

Flex Yemen هو تطبيق شامل للتجارة الإلكترونية والمدفوعات الرقمية في اليمن. يوفر التطبيق:

- 🛒 **متجر إلكتروني** مع 40+ فئة من المنتجات
- 💳 **محفظة رقمية** متعددة العملات
- 💬 **نظام محادثات** بين المشترين والبائعين
- 🗺️ **خرائط تفاعلية** لتحديد المواقع
- 👤 **لوحات تحكم** للبائعين والمشرفين

---

## ✨ المميزات

### التجارة الإلكترونية
- ✅ عرض المنتجات مع صور وأسعار
- ✅ 40+ فئة متنوعة
- ✅ بحث متقدم مع فلاتر
- ✅ سلة تسوق وإتمام شراء
- ✅ تتبع الطلبات
- ✅ تقييم المنتجات
- ✅ قائمة المفضلة

### المحفظة الرقمية
- ✅ رصيد متعدد العملات (YER)
- ✅ إيداع وسحب
- ✅ تحويل داخلي
- ✅ دفع فواتير
- ✅ شحن رصيد جوال
- ✅ بطاقات هدايا
- ✅ محافظ يمنية متكاملة

### المحادثات
- ✅ محادثة فورية
- ✅ إرسال الصور والمنتجات
- ✅ إشعارات الرسائل
- ✅ Realtime مع Supabase

---

## 🛠️ التقنيات المستخدمة

| التقنية | الاستخدام |
|---------|----------|
| Flutter 3.22.0 | إطار العمل |
| Dart 3.4.0 | لغة البرمجة |
| Supabase | قاعدة البيانات والمصادقة |
| Provider | إدارة الحالة |
| Flutter Map | الخرائط التفاعلية |
| Local Auth | البصمة و Face ID |

---

## 📁 هيكل المشروع

```
flex_yemen/
├── lib/
│   ├── main.dart                 # نقطة الدخول
│   ├── core/                     # الثوابت والأدوات
│   │   ├── constants/            # الثوابت
│   │   ├── theme/                # السمات
│   │   ├── utils/                # الأدوات
│   │   └── routes/               # المسارات
│   ├── models/                   # النماذج (40+ ملف)
│   ├── services/                 # الخدمات (25+ ملف)
│   ├── providers/                # مزودي الحالة (15+ ملف)
│   ├── screens/                  # الشاشات (70+ ملف)
│   └── widgets/                  # الويدجت (50+ ملف)
├── assets/                       # الأصول
├── supabase/                     # إعدادات Supabase
└── pubspec.yaml                  # التبعيات
```

---

## 🚀 التشغيل

### المتطلبات
- Flutter 3.22.0 أو أحدث
- Dart 3.4.0 أو أحدث
- Android SDK 23+
- Xcode (للبناء على iOS)

### خطوات التشغيل

1. **استنساخ المشروع**
```bash
git clone https://github.com/flexyemen/flex_yemen.git
cd flex_yemen
```

2. **تثبيت التبعيات**
```bash
flutter pub get
```

3. **إعداد البيئة**
- أنشئ ملف `.env` في المجلد الرئيسي
- أضف متغيرات Supabase:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. **تشغيل التطبيق**
```bash
flutter run
```

---

## 📦 بناء APK

### إصدار Debug
```bash
flutter build apk
```

### إصدار Release
```bash
flutter build apk --release
```

### App Bundle (لـ Google Play)
```bash
flutter build appbundle
```

---

## ⚙️ إعداد Supabase

### الجداول المطلوبة

```sql
-- المستخدمين
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  phone TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- المنتجات
CREATE TABLE products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL NOT NULL,
  quantity INTEGER DEFAULT 0,
  images TEXT[],
  category_id UUID REFERENCES categories,
  seller_id UUID REFERENCES profiles,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- الطلبات
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles,
  total DECIMAL NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

-- المحفظة
CREATE TABLE wallets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles,
  balance DECIMAL DEFAULT 0,
  currency TEXT DEFAULT 'YER',
  created_at TIMESTAMP DEFAULT NOW()
);

-- المعاملات
CREATE TABLE wallet_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  wallet_id UUID REFERENCES wallets,
  type TEXT NOT NULL,
  amount DECIMAL NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🎨 الألوان

| اللون | الكود | الاستخدام |
|-------|-------|----------|
| الذهبي | `#D4AF37` | اللون الأساسي |
| الذهبي الفاتح | `#FFD700` | التأكيد |
| الذهبي الداكن | `#B8860B` | الظلال |

---

## 🤝 المساهمة

نرحب بمساهماتكم! يرجى اتباع الخطوات التالية:

1. Fork المشروع
2. إنشاء فرع جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push للفرع (`git push origin feature/amazing-feature`)
5. فتح Pull Request

---

## 📄 الترخيص

هذا المشروع مرخص بموجب [MIT License](LICENSE).

---

## 📞 التواصل

- البريد الإلكتروني: support@flexyemen.com
- الموقع: https://flexyemen.com
- تويتر: [@FlexYemen](https://twitter.com/flexyemen)

---

<p align="center">
  <strong>صنع بـ ❤️ في اليمن</strong>
</p>
