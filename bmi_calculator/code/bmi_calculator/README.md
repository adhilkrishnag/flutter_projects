# BMI Calculator 📏

A Flutter-based BMI Calculator web application featuring a modern UI with gradient backgrounds, glassmorphism cards, input validation, and a reset button. This project showcases professional Flutter development skills for recruiters, demonstrating clean code and user-friendly design.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## ✨ Features

- **BMI Calculation**: Compute Body Mass Index from height, weight, and age inputs.
- **Modern UI**: Gradient backgrounds and glassmorphism cards for a sleek, engaging interface.
- **Input Validation**: Ensures valid numeric inputs for height, weight, and age.
- **Reset Button**: Clear inputs and results with a single tap.
- **Web Support**: Optimized for Flutter web, with potential for Android/iOS.

## 📋 Prerequisites

- **Flutter SDK**: Version 3.0.0 or higher
- **IDE**: Android Studio, VS Code, or any Flutter-compatible IDE
- **Dart Packages**: Specified in `pubspec.yaml`
- **Web Browser**: Chrome for testing

## 🚀 Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/adhilkrishnag/flutter_projects/tree/main/bmi_calculator/code/bmi_calculator
cd flutter_projects/bmi_calculator
```

### 2. Install Dependencies 📦
Update `pubspec.yaml`:
| Package                  | Version   |
|--------------------------|-----------|
| `flutter`                | SDK       |
| `flutter_test` (dev)     | SDK       |
| `flutter_lints` (dev)    | ^4.0.0    |

Run:
```bash
flutter pub get
```

### 3. Enable Web Support 🌐
Enable Flutter web:
```bash
flutter config --enable-web
```
Verify:
```bash
flutter devices
```
Ensure a browser (e.g., Chrome) is listed.

### 4. Run the App 🏃
Run locally:
```bash
flutter run -d chrome
```

### 5. Project Structure 📂
| Path                              | Description                              |
|-----------------------------------|------------------------------------------|
| `lib/screens/`                    | UI screens                               |
| `lib/screens/input_page.dart`     | Main screen with input fields, results   |
| `lib/widgets/`                    | Reusable UI components                   |
| `lib/main.dart`                   | App entry point                          |
| `web/index.html`                  | Web app configuration                    |

## 🖥️ Usage
- **Input Fields**:
  - Enter *height* (cm), *weight* (kg), and *age* using numeric inputs.
  - Invalid inputs trigger error messages via `SnackBar`.
- **Calculate BMI**:
  - Tap the calculate button to view BMI and health category (e.g., Normal, Overweight).
- **Reset**:
  - Tap the reset button to clear all inputs and results.
- **UI**:
  - Enjoy gradient backgrounds and glassmorphism cards for a modern look.

## 🔒 Security Features
- **Input Validation**: Ensures non-empty and numeric inputs for accurate calculations.
- **Error Handling**: User-friendly `SnackBar` feedback for invalid inputs.

## <details><summary>🛠️ Troubleshooting</summary>

- **Flutter Web Errors**:
  - Verify `flutter config --enable-web` is set.
  - Check Chrome DevTools > Console for errors.
  - Run `flutter clean` and `flutter pub get` if build fails.
- **UI Issues**:
  - Verify widget tree in `input_page.dart` for layout errors.
  - Ensure gradient and glassmorphism styles are applied in `input_page.dart`.

</details>

## 📜 License
MIT License. See [LICENSE](LICENSE) for details.

## 🤝 Contributing
Contributions are welcome! Submit a pull request or open an issue for bugs or features.

Built with **Flutter** to showcase modern app development for recruiters.