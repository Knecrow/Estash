<div align="center">

![Estash Banner](assets/banner.jpg)

# ⚡ Estash
### Modern Personal Finance & Daily Budget Tracker

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green?style=for-the-badge)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

<p align="center">
  A sleek, ultra-fast personal finance and daily budget tracking application built with Flutter, designed around a custom Paynx-inspired dark theme with dynamic status alerts, fluid micro-animations, and full multi-currency support.
</p>

</div>

---

## 🌟 Key Features

### 🟢 Dynamic Hero Status Card
- **Automated Color Shifts**: The top main hero header dynamically transitions background and typography colors based on your financial health:
  - 🟢 **Safe Mode (Vibrant Neon Lime `#B5F520`)**: Active when total balance is positive and daily spending is under 70% of your cap.
  - 🟡 **Warning Mode (Electric Yellow `#FFD600`)**: Triggers when today's spending reaches 70%–90% of your daily cap.
  - 🔴 **Danger Mode (Electric Crimson Red `#FF3333`)**: Triggers when spending exceeds 90% of your daily cap OR if your balance becomes negative.

### 🎨 Custom Dark & Slate Steel Aesthetic
- **Canvas Background**: Deep pitch dark canvas (`#0D0F12`).
- **Slate Steel Body Cards**: Custom Slate Steel Grey (`#353A40`) surface with elevated charcoal badges (`#26292E`).
- **Borderless Flat Styling**: Zero drop shadows, zero border strokes, and pure solid color blocks for a clean, modern aesthetic.

### 🌍 Global Multi-Currency Support
- **36 World Currencies**: Built-in support for US Dollar (`USD`), Euro (`EUR`), British Pound (`GBP`), Japanese Yen (`JPY`), Indian Rupee (`INR`), Kuwaiti Dinar (`KWD`), UAE Dirham (`AED`), Saudi Riyal (`SAR`), and 28+ more.
- **Searchable Currency Picker**: Live search by country name, currency name, code, or symbol in Settings.

### 💸 Streamlined Income & Expense Management
- **Zero Friction Entry**: Modal entry sheets with quick haptic keypad.
- **Auto-Category Handling**: Income entries bypass category selection automatically.
- **Categorized Spending Analytics**: Interactive donut chart & time-series bar charts for daily, weekly, and monthly tracking.

### ✨ Butter-Smooth Animations & Micro-Interactions
- **Numeric Counter Rolls (`AnimatedCurrencyText`)**: Smoothly animates numbers when total balance or daily spend changes.
- **Tactile Scale Feedback (`SmoothTapScale`)**: Subtle press scale feedback on cards and buttons.
- **Staggered Entrance (`StaggeredEntrance`)**: Fade & slide entrance animations for lists and cards.
- **Animated Tab Switching (`AnimatedSwitcher`)**: Smooth page transitions between Dashboard, Analytics, and Settings.

### 🔔 Notifications & Data Privacy
- **30-Minute Reminders**: Toggleable local periodic reminders.
- **Local Persistence**: All transaction and setting data stored locally using Hive & SharedPreferences.
- **Data Reset**: Full wipe & restore defaults option under Settings.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter 3.x](https://flutter.dev) (Dart)
- **State Management**: `provider`
- **Local Storage**: `hive` & `shared_preferences`
- **Charts**: `fl_chart`
- **Haptics**: `flutter_vibrate` / `services`
- **Notifications**: `flutter_local_notifications`

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Knecrow/Estash.git

# 2. Navigate to project directory
cd Estash

# 3. Get dependencies
flutter pub get

# 4. Run code generation (if modifying Hive adapters)
dart run build_runner build --delete-conflicting-outputs

# 5. Launch the app
flutter run
```

---

## 📄 License

This project is licensed under the **MIT License**.
