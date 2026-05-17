# AlignOne

AlignOne is a beautiful, minimalist mobile app built with Flutter that helps users commit to exactly one meaningful aligned action per day tied to their personal life priorities.

![App Dashboard Placeholder](https://via.placeholder.com/400x800?text=AlignOne+Dashboard)

## Tech Stack
* **Framework:** Flutter (stable)
* **Language:** Dart
* **State Management:** Provider
* **Backend / Auth:** Supabase (PostgreSQL)

## Prerequisites
* Flutter SDK (latest stable channel)
* Android Studio / Xcode
* Supabase Account

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/align_one.git
cd align_one
```

### 2. Supabase Setup
1. Create a new project in your Supabase dashboard.
2. Go to **Project Settings** -> **API** to copy your `Project URL` and `anon public` key.
3. Replace the placeholders in `lib/main.dart` with your Supabase credentials:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```
4. Run the SQL schema found in `supabase_schema.sql` via the Supabase SQL Editor. This script creates the required tables (`profiles`, `life_areas`, `daily_actions`), sets up Row Level Security (RLS) policies, and configures triggers.

### 3. Run Locally
```bash
flutter pub get
flutter run
```

## Build the App Manually

### Android
To build an Android APK manually:
```bash
flutter build apk --release
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

### iOS
To build for iOS, you must configure code signing in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Go to the **Runner** target -> **Signing & Capabilities**.
3. Select your development team.
4. Run `flutter build ios` or build directly from Xcode.

## CI/CD Workflow (GitHub Actions)
This project includes a fully configured GitHub Actions workflow (`.github/workflows/build-android.yml`) that automatically builds an Android APK whenever code is pushed to the `main` branch.

**How it works:**
1. Triggers on push or pull request to the `main` branch.
2. Sets up an Ubuntu environment with Java 17 and Flutter (stable).
3. Fetches dependencies (`flutter pub get`).
4. Runs linting/analysis (`flutter analyze`).
5. Builds a release APK (`flutter build apk --release`).
6. Uploads the generated `.apk` file as a downloadable artifact.

To access the built APK, go to the **Actions** tab in your GitHub repository after a successful workflow run and download the `release-apk` artifact.
