# 📱 Flutter Projects

Welcome to my **Flutter Projects Repository** — a curated collection of Flutter applications showcasing modern UI/UX, clean code, and professional development skills. Built to demonstrate expertise in Flutter and Dart, this portfolio includes mini-apps for learning and experimentation, each with its own source code optimized for web and mobile platforms.

## ✨ About

This repository houses a set of Flutter projects designed to highlight skills in building responsive, user-friendly applications. Each project emphasizes modern design principles, robust functionality, and scalable architecture.

## 🧭 Repository Structure

Each project follows a consistent structure within its subfolder:

| Path | Description |
| --- | --- |
| `lib/` | Source code (screens, widgets, etc.) |
| `web/` | Web app configuration |
| `pubspec.yaml` | Project dependencies |
| `README.md` | Project-specific documentation |

### 📂 Projects

| Project | Description | Key Features |
| --- | --- | --- |
| **BMI Calculator** | A web app to calculate BMI with a modern UI, featuring input validation and a reset button. | Gradient backgrounds, glassmorphism cards, input validation. |
| **Chat App** | A real-time chat app using Firebase, with secure authentication and messaging. | Firebase Auth/Firestore, BLoC pattern, real-time messaging |

## 📋 Prerequisites

- **Flutter SDK**: Version 3.0.0 or higher
- **IDE**: Android Studio, VS Code, or any Flutter-compatible IDE
- **Dart Packages**: Specified in each project’s `pubspec.yaml`
- **Web Browser**: Chrome for testing web apps
- **Firebase Account**: Required for `chat_app` (optional for other projects)

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/adhilkrishnag/flutter_projects.git
cd flutter_projects
```

### 2. Navigate to a Project

Choose a project to explore:

```bash
cd bmi_calculator
# or
cd chat_app
```

### 3. Install Dependencies 📦

Each project has its own `pubspec.yaml`. Common dependencies include:

| Package | Version |
| --- | --- |
| `flutter` | SDK |
| `flutter_test` (dev) | SDK |
| `flutter_lints` (dev) | ^4.0.0 |

Project-specific dependencies:

- **BMI Calculator**: Minimal dependencies (no external packages).
- **Chat App**: Includes `flutter_bloc: ^9.0.1`, `firebase_core: ^3.6.0`, etc.

Run:

```bash
flutter pub get
```

### 4. Enable Web Support 🌐

Enable Flutter web:

```bash
flutter config --enable-web
```

Verify:

```bash
flutter devices
```

Ensure a browser (e.g., Chrome) is listed.

### 5. Run the App 🏃

Run locally:

```bash
flutter run -d chrome
```

For `chat_app`, configure Firebase as described in its README.

## 🛠️ Troubleshooting

- **Flutter Web Errors**:
  - Verify `flutter config --enable-web` is set.
  - Check Chrome DevTools &gt; Console for errors.
  - Run `flutter clean` and `flutter pub get` if build fails.
- **Dependency Issues**:
  - Ensure `pubspec.yaml` matches the project’s requirements.
  - Run `flutter pub upgrade` for outdated packages.
- **Chat App Specific**:
  - Verify Firebase setup (`google-services.json`, `.env`) in `chat_app`.
  - Check Firestore rules and network connectivity.
- **UI Issues**:
  - For `bmi_calculator`, ensure gradient and glassmorphism styles are applied in `input_page.dart`.
  - For `chat_app`, confirm UI styles are applied in `main.dart`.

## 📜 License

MIT License. See LICENSE for details.

## 🤝 Contributing

Contributions are welcome! Submit a pull request or open an issue for bugs or features.

Built with **Flutter** to highlight modern app development skills.
