# FROST XTREME

سیستم کنترل صنعتی خنک‌کننده — اپلیکیشن Flutter (داشبورد + بلوتوث + هشدار + گزارش‌گیری).

## راه‌اندازی

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

دستور `build_runner` برای تولید فایل `lib/models/device_data.g.dart` لازم است
(چون `device_data.dart` با آنوتیشن‌های `@HiveType/@HiveField` نوشته شده).

## نکات مهم دربارهٔ این پکیج (چیزهایی که در گفتگوی اصلی کم بود و اضافه/اصلاح شد)

1. **`lib/main.dart`** در فایل اصلی داده نشده بود — اینجا از صفر نوشته شد تا
   Provider ها، Hive، و ۴ صفحه (داشبورد/هشدارها/گزارشات/تنظیمات) را با یک
   navigation bar پایین صفحه به هم وصل کند.
2. **`lib/services/database_service.dart`** در `device_provider.dart`
   ایمپورت شده بود ولی متن آن در گفتگو نیامده بود — نسخه‌ای بر پایهٔ Hive
   نوشته شد که با باکس‌ها/ثابت‌های بقیهٔ پروژه هماهنگ است.
3. **`android/app/src/main/AndroidManifest.xml`** از صفر نوشته شد (پرمیشن‌های
   بلوتوث/نوتیفیکیشن/شبکه لازم برای پکیج‌های استفاده‌شده).
4. **`lib/models/device_data.dart` و `lib/models/alarm.dart`**: ایمپورت‌های
   گمشدهٔ `material.dart` و `theme.dart` اضافه شد (در متن اصلی، این دو فایل
   از `Colors`/`IconData`/`AppTheme` استفاده می‌کردند بدون ایمپورت).
5. **`lib/services/bluetooth_service.dart`**: با API واقعی پکیج
   `flutter_blue_plus` (نسخهٔ ذکرشده در pubspec) بازنویسی شد — کد اصلی از
   متدهایی مثل `scanAndConnect` استفاده می‌کرد که در این پکیج وجود ندارد.
6. **`assets/`**: فایل‌های فونت (`Orbitron-Black.ttf`, `Rajdhani-Bold.ttf`)،
   فایل‌های Rive (`compressor.riv`, `water_flow.riv`) و آیکون اپ در گفتگوی
   اصلی ارائه نشده بودند — پوشه‌ها ساخته شده‌اند ولی باید فایل‌های واقعی را
   خودتان اضافه کنید (وگرنه build روی فونت‌ها/asset ها خطا می‌دهد؛ در این
   حالت می‌توانید موقتاً بخش `fonts:` و مسیرهای rive را از `pubspec.yaml`
   حذف کنید تا فقط با فونت‌های گوگل پیش‌فرض اجرا شود).

## ساختار
دقیقاً همان ساختاری که در گفتگو مشخص شده بود، به‌علاوهٔ موارد بالا.

## خروجی گرفتن
```bash
flutter build apk --release
flutter build windows
flutter build ios
```
