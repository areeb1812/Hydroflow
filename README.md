# 💧 HydroFlow — Premium Water Intake Tracker

[![Flutter](https://img.shields.io/badge/Flutter-3.44.8-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-brightgreen)](#)

**HydroFlow** is a modern, high-performance Flutter Android application designed to help users track their daily hydration goals seamlessly. Featuring an animated dual-sine wave liquid visualizer, futuristic dark glassmorphic UI, customizable presets, weekly analytics, and offline persistence.

---

## ✨ Features

- 🌊 **Animated Liquid Wave Visualizer**: Custom-painted sine wave physics with glowing cyan liquid heights that reflect real-time daily goal progress.
- ⚡ **Quick Logging & Custom Volume**: 1-tap quick add buttons (**Glass 250ml**, **Bottle 500ml**, **Flask 750ml**, **Jug 1000ml**) and a custom input modal sheet with real-time `ml` / `fl oz` unit conversion.
- 🔥 **Streak Tracker**: Automatic daily streak calculation when meeting daily intake targets.
- 📊 **Weekly Analytics & History**: Interactive 7-day bar charts highlighting goal-achievement days, plus full daily intake timeline with swipe-to-delete and undo support.
- ⚙️ **Goal & Reminder Preferences**: Adjustable daily target slider (1,000 ml – 5,000 ml), unit switcher (`ml` vs `fl oz`), and customizable reminder intervals.
- 💾 **Offline Local Storage**: Instant loading and data retention powered by `SharedPreferences`.
- 📱 **Zero Pixel Overflows**: Built with responsive layout constraints and scale-down protections across all phone screen sizes and orientations.

---

## 🛠️ Tech Stack & Packages

| Package | Version | Purpose |
|---|---|---|
| **Flutter SDK** | `^3.44.8` | Cross-platform framework |
| **Provider** | `^6.1.2` | App state management (`ChangeNotifier`) |
| **Google Fonts** | `^6.2.1` | Typography (Outfit font family) |
| **Shared Preferences** | `^2.3.2` | Offline local data persistence |
| **Intl** | `^0.19.0` | Date and time formatting |

---

## 📂 Project Architecture

```text
lib/
├── main.dart                  # App entry point, dark theme setup & bottom navigation
├── models/
│   ├── water_log.dart         # Intake entry data model
│   └── user_settings.dart     # Daily goal, units, streak & reminder configuration
├── services/
│   └── storage_service.dart   # Local SharedPreferences wrapper
├── providers/
│   └── hydration_provider.dart# State management logic & calculations
├── widgets/
│   ├── wave_liquid_painter.dart# CustomPainter for animated sine wave liquid
│   ├── glass_card.dart        # Reusable glassmorphic card container
│   ├── quick_add_button.dart  # Micro-animated intake preset buttons
│   └── weekly_chart.dart      # 7-day hydration bar chart
└── screens/
    ├── home_screen.dart       # Dashboard screen with wave & quick log
    ├── history_screen.dart    # Weekly analytics & timeline history
    └── settings_screen.dart   # Daily goal, units & reminder settings
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
- An Android Emulator (API 33+) or physical Android device

### Installation & Execution

1. **Clone the repository**:
   ```bash
   git clone https://github.com/areeb1812/Hydroflow.git
   cd Hydroflow
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify code quality**:
   ```bash
   dart analyze
   ```

4. **Run unit tests**:
   ```bash
   flutter test
   ```

5. **Launch application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

HydroFlow includes automated widget tests. Run tests via terminal:
```bash
flutter test
```

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

Developed with ❤️ by [Areeba Naz](https://github.com/areeb1812).
