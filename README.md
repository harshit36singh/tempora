# Tempora ⏰

A beautiful, minimalist Flutter weather and clock application with a focus on clean design and smooth animations.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## 📱 Features

### 🏠 Home Clock
- **Real-time clock display** with customizable 12h/24h format
- **Current location** with automatic geolocation
- **Live weather** integration showing temperature and conditions
- **Clean, minimalist UI** with Inter font and smooth animations

### ☀️ Weather Page
- **Detailed weather information**:
  - Current temperature and conditions
  - Feels like temperature
  - High/Low temperatures
  - Humidity and wind speed
  - Atmospheric pressure
  - Cloud coverage
  - Visibility
- **8-hour forecast** with visual weather icons
- **Real-time updates** from OpenWeatherMap API

### 🔍 Search
- **Global city search** functionality
- **Instant weather display** for any searched location
- **Clean search interface** with autocomplete suggestions
- **Quick access** to weather data for multiple cities

### 🌍 World Clock
- **8 major cities** with live time updates
- **Time zone offsets** clearly displayed
- **Time-of-day indicators**:
  - Morning (orange)
  - Afternoon (blue)
  - Evening (purple)
  - Night (dark blue)
- **City emojis** for visual identification
- **Local time display** at the top

## 🎨 Design

The app features a **minimalist design philosophy** with:
- Clean white backgrounds (#F6F6F6)
- Black accents for buttons and active states
- Inter font family throughout
- Smooth transitions and animations
- Responsive sizing for all screen sizes
- Circular navigation buttons with active state indicators

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- An OpenWeatherMap API key (free tier available)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/tempora.git
cd tempora
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Add your API key**

Open `lib/main.dart`, `lib/weather.dart`, and `lib/search.dart` and replace the API key:
```dart
const String apiKey = 'YOUR_API_KEY_HERE';
```

Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)

4. **Run the app**
```bash
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  http: ^1.1.0
```

### Key Packages

- **google_fonts**: Inter font family for consistent typography
- **geolocator**: Location services for automatic city detection
- **geocoding**: Reverse geocoding for location names
- **http**: API requests to OpenWeatherMap

## 🏗️ Project Structure

```
lib/
├── main.dart           # Main app entry point and home clock page
├── weather.dart        # Detailed weather page
├── search.dart         # City search functionality
├── clock.dart          # World clock page
└── navbar.dart         # Custom navigation component
```

## 🔧 Configuration

### Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS Permissions

Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location for weather information.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location for weather information.</string>
```

## 🎯 Features Breakdown

### Home Screen
- Displays current time in large, readable format
- Shows weekday and date
- Displays current location (city, state, country)
- Shows current temperature and weather condition
- Toggle between 12h and 24h time formats
- Tap weather icon to view detailed weather page

### Weather Screen
- Comprehensive weather data display
- Weather emoji indicators
- High/low temperature range
- Atmospheric conditions (pressure, humidity, wind)
- Hourly forecast cards
- Smooth scrolling interface

### Search Screen
- Search for any city worldwide
- Auto-suggestions as you type
- Tap to view weather for selected city
- Clean results with country and state information
- Quick weather overview for searched locations

### World Clock Screen
- 8 pre-configured major cities
- Real-time updates for all time zones
- Visual time-of-day indicators
- UTC offset display
- Smooth animations

## 🎨 Customization

### Adding More Cities to World Clock

Edit the `cities` list in `lib/clock.dart`:
```dart
final List<Map<String, dynamic>> cities = [
  {"name": "City Name", "country": "Country", "offset": 0, "emoji": "🌆"},
  // Add more cities here
];
```

### Changing Theme Colors

Modify colors in respective files:
- Background: `const Color(0xFFF6F6F6)`
- Active buttons: `Colors.black`
- Inactive buttons: `Colors.black54`
