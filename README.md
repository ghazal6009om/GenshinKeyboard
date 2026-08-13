# Genshin Keyboard 🗿

لوحة مفاتيح iOS (امتداد كيبورد للآيباد/الآيفون) تكتب العربية بشكل صحيح في شات
Genshin Impact، الذي لا يعرض الحروف العربية بشكل سليم (تظهر **معكوسة** ومفكوكة) —
بمنطق تشكيل عربي خالص مكتوب بـ Swift (بدون Python).

التخطيط متكيّف مع الآيباد: مفاتيح أكبر، تباعد أوسع، وخطوط أعلى.

## ما المشكلة التي تحلها؟
شات Genshin لا يربط الحروف العربية، فتبدو الكلمات هكذا: **سلام** ← **س ل ا م**
بدل الشكل المتصل: **سلام**.

هذا الامتداد يعالج النص قبل إرساله:
1. **التشكيل** (`ArabicShaping.swift`): يبدّل الحروف إلى أشكالها العرضية
   (initial / medial / final) ويكوّن الليجاتورات مثل «لا».
2. **عكس الاتجاه**: يرتب النص ليظهر بصرياً بشكل صحيح داخل اللعبة.

## هيكل المشروع
```
project.yml                    ← إعداد XcodeGen (يولّد .xcodeproj)
Sources/
  GenshinKeyboard/             ← التطبيق المضيف (صفحة تعليمات)
    AppDelegate.swift
    Info.plist
  GenshinKeyboardKeyboard/     ← امتداد الكيبورد نفسه
    KeyboardViewController.swift
    ArabicShaping.swift
    Info.plist
.github/workflows/build.yml    ← CI يبني IPA حقيقي (غير موقّع)
LegacyPython/                  ← النسخة القديمة (Python + محاكي) احتياط
```

## البناء محلياً (macOS + Xcode)

```bash
brew install xcodegen
xcodegen generate            # يولّد GenshinKeyboard.xcodeproj
open GenshinKeyboard.xcodeproj
```

- اختر Signing & Capabilities ← Team (حساب Apple مجاني يكفي).
- فعّل على جهازك: الإعدادات ← عام ← VPN وإدارة الأجهزة ← ثِق بالتطبيق.
- شغّل على الجهاز، ثم فعّل الكيبورد:
  **الإعدادات ← عام ← لوحة المفاتيح ← لوحات المفاتيح ← إضافة لوحة مفاتيح جديدة ← Genshin Keyboard**.
- في الكيبورد: فعّل **Genshin Mode**، اكتب، ثم اضغط **إرسال**.

## البناء عبر GitHub Actions (بدون Xcode على جهازك)
ارفع المشروع إلى GitHub، وستجد في **Actions** ملف `GenshinKeyboard-Real-IPA`.
هذا الـ IPA **غير موقّع**، وقبل تثبيته عليك إعادة توقيعه على جهازك:

### بسرعة عبر Sideloadly (ويندوز/ماك)
1. نزّل [Sideloadly](https://sideloadly.io).
2. وصّل الآيفون، اسحب الـ IPA، أدخل Apple ID (فوري/مجاني).
3. ثبّت، ثم **الإعدادات ← عام ← إدارة الأجهزة ← ثِق**.
4. فعّل الكيبورد كما في الخطوات أعلاه.

### عبر AltStore (باقٍ 7 أيام)
1. ثبّت AltStore عبر AltServer (Sideloadly أسهل للمرة الأولى).
2. افتح AltStore ← My Apps ← أضف الـ IPA.
3. بعد انتهاء الأيام السبعة: AltStore ← Refresh لإعادة التوقيع.

> ملاحظة: توقيع مجاني يدوم 7 أيام فقط. التوقيع المدفوع (حساب مطوّر 99$/سنة) يجعل
> التثبيت يدوم سنة ولا يتطلب إعادة ثِق.

## الاستخدام
| الزر | الوظيفة |
|------|---------|
| Genshin Mode: ON/OFF | يفعل تشكيل العربية وربط الحروف قبل الإرسال |
| ⌫ | مسح آخر حرف |
| C | مسح كل النص |
| مسافة | مسافة |
| إرسال | يضع النص في الحقل (مشكّلاً في وضع Genshin) |
| 🌐 | التبديل إلى كيبورد آخر |

## ملاحظات تقنية
- المنطق يعتمد على Presentation Forms-A (U+FB50–U+FEFF) لتشكيل الحروف،
  ونفسه المستخدم في `python-arabic-reshaper` سابقاً.
- `NSExtensionPrincipalClass` هو `$(PRODUCT_MODULE_NAME).KeyboardViewController`.
- الامتداد لا يتطلب `RequestOpenAccess` لأن النص يُحقن عبر `UITextDocumentProxy` مباشرة.
- للتفعيل المباشر داخل التطبيق المضيف نفسه اقرأ `Sources/GenshinKeyboard/AppDelegate.swift`.
