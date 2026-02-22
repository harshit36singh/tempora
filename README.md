# Tempora 🌦️

A modern, minimalist **Flutter weather application** focused on clean UI, smooth animations, and intuitive gesture-based navigation. Tempora supports **multiple saved cities**, **location-based weather**, and **vertical + horizontal swipe navigation**.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

---

## 🎥 Demo

![Tempora Demo](https://github.com/harshit36singh/tempora/raw/main/assets/showcase.gif)
---

## 📱 Features

### 🌍 Multi-City Weather
- Add **multiple cities** using search
- Swipe **horizontally** between cities
- Cities are **persisted locally** using SharedPreferences
- Auto-loads saved cities on app restart

### 📍 Location-Based Weather
- Fetches weather using **device location**
- Automatically adds current location if no cities are saved
- Permission-safe handling using Geolocator

### 📊 Detailed Weather Data
- Current temperature, feels-like temperature, humidity
- Wind speed, pressure, cloud coverage, visibility
- Sunrise & sunset times

### 🧭 Gesture-Driven Navigation
- **Horizontal swipe** → switch cities
- **Vertical swipe** → reveal detailed weather
- Swipe hint indicator for discoverability

### 🎨 Dynamic UI
- Weather-based theme colors with automatic light/dark contrast
- Smooth animations using `flutter_animate`
- Clean, flat, minimalist design

---

## 🖼️ UI Highlights

- Full-screen weather views with vertical stacked pages (main + details)
- Page indicators for city navigation
- Square dialog with weather-aware gradient background
- Custom in-app menu icon from assets

---

## 🏗️ Project Structure

```
lib/
├── models/
│   └── weather_model.dart       # Weather data model
├── screens/
│   ├── home_screen.dart         # Main app screen
│   └── splash_screen.dart       # App splash screen
├── services/
│   └── weather_service.dart     # API + location logic
├── widgets/
│   ├── weather_widget.dart      # Swipe-based weather UI
│   └── swipeup.dart             # Swipe-up hint indicator
└── main.dart                    # App entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK **3.0+**
- Dart SDK **3.0+**
- OpenWeatherMap API key

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/yourusername/tempora.git
cd tempora
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Create a `.env` file in the project root**
```
OPEN_WEATHER_API_KEY=your_api_key_here
```

**4. Load environment variables in `main.dart`**
```dart
await dotenv.load();
```

**5. Run the app**
```bash
flutter run
```

---

## 🔑 Weather API

Tempora uses the [OpenWeatherMap API](https://openweathermap.org/api) for real-time weather data (city-based, location-based, metric units). Get a free API key at **openweathermap.org/api**.

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_animate: ^4.5.0
  google_fonts: ^6.1.0
  http: ^1.1.0
  geolocator: ^10.1.0
  intl: ^0.19.0
  flutter_dotenv: ^5.1.0
  shared_preferences: ^2.2.2
```

---

## 🔧 Platform Permissions

**Android** — `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**iOS** — `ios/Runner/Info.plist`
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show weather data.</string>
```

---

## 🎯 Navigation Guide

| Gesture | Action |
|---|---|
| Swipe left / right | Switch cities |
| Swipe up | View detailed weather |
| Tap ➕ | Add new city |
| Restart app | Cities persist |
