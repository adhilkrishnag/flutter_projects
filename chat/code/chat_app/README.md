Chat App
A Flutter-based chat application using Firebase for authentication and real-time messaging, with secure storage for user tokens (non-web). The app uses the BLoC pattern for state management, ensuring a reactive and maintainable architecture without setState. Supports Android, iOS, and web platforms.
Features

Authentication: Sign up and sign in with email and password using Firebase Authentication.
Real-Time Chat: Send and receive messages in real-time using Firestore.
Secure Storage: Store user tokens securely using flutter_secure_storage (Android/iOS only).
BLoC Pattern: Reactive state management for authentication and chat functionality.
Responsive UI: Clean and intuitive interface for login and chat screens across platforms.

Prerequisites

Flutter SDK: Version 3.0.0 or higher.
Firebase Account: Required for authentication and Firestore.
IDE: Android Studio, VS Code, or any Flutter-compatible IDE.
Dart Packages: Listed in pubspec.yaml.
Web Browser: For testing web app (e.g., Chrome).

Setup Instructions
1. Clone the Repository
git clone https://github.com/your-username/flutter_projects/chat_app.git
cd chat_app

2. Configure Firebase

Create a Firebase project at Firebase Console.
Enable Email/Password authentication:
Go to Authentication > Sign-in method > Enable Email/Password provider.


Enable Firestore:
Go to Firestore Database > Create database (start in test mode).


Add apps to your Firebase project (Project settings > General > Your apps):
Android:
Package name: com.example.chat_app
Download google-services.json and place in android/app/.


iOS:
Bundle ID: com.example.chatApp
Download GoogleService-Info.plist and place in ios/Runner/.


Web:
Register web app and copy Firebase configuration.
Create a .env file in the project root with:FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your-messaging-sender-id
FIREBASE_APP_ID=your-app-id






Apply Firestore security rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /messages/{messageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}

3. Install Dependencies
Add the following to pubspec.yaml:
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  flutter_secure_storage: ^9.2.2
  flutter_bloc: ^8.1.5
  equatable: ^2.0.5
  flutter_dotenv: ^5.1.0

Run:
flutter pub get

4. Update Platform Configurations

Android:
In android/app/src/main/AndroidManifest.xml, set:<application
    android:label="Chat App"
    ...>


Ensure google-services.json is in android/app/.
Update android/build.gradle:classpath 'com.google.gms:google-services:4.4.2'


Update android/app/build.gradle:apply plugin: 'com.google.gms.google-services'




iOS:
In ios/Runner/Info.plist, set:<key>CFBundleName</key>
<string>Chat App</string>


Ensure GoogleService-Info.plist is in ios/Runner/.


Web:
Ensure .env is configured with Firebase web app credentials.
Verify web/index.html includes Firebase SDK.



5. Enable Web Support

Ensure Flutter web is enabled:flutter config --enable-web


Verify web support:flutter devices

You should see a browser (e.g., Chrome) listed.

6. Run the App

Android/iOS:
Connect a device/emulator.
Run:flutter run




Web:
Run:flutter run -d chrome





7. Project Structure
lib/
├── auth/
│   ├── bloc/                 # Authentication BLoC logic
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   ├── auth_state.dart
│   ├── auth_repository.dart  # Authentication repository
├── chat/
│   ├── bloc/                 # Chat BLoC logic
│   │   ├── chat_bloc.dart
│   │   ├── chat_event.dart
│   │   ├── chat_state.dart
│   ├── chat_repository.dart  # Chat repository
├── screens/
│   ├── auth_wrapper.dart     # Decides login or chat screen
│   ├── login_screen.dart     # Login UI
│   ├── chat_screen.dart      # Chat UI
├── main.dart                 # App entry point
web/
├── index.html                # Firebase SDK for web

Usage

Login Screen:
Enter email and password to sign in or sign up.
Toggle between sign-in and sign-up modes using the text button.
Errors are displayed via SnackBars.


Chat Screen:
View real-time messages from all users.
Send messages using the text field and send button.
Messages are aligned right (self) or left (others).
Sign out using the logout button in the AppBar.



Security Features

Firestore Rules: Only authenticated users can read/write messages.
Secure Storage: User tokens are stored securely on Android/iOS; web relies on Firebase Authentication.
Input Validation: Ensures non-empty email and password fields.
Environment Variables: Firebase keys are stored in .env and not committed.

Extending the App
To add features, consider:

Message Timestamps: Add a formatted timestamp to each message.
User Profiles: Store and display user avatars or names.
Offline Support: Cache messages using Firestore's offline persistence.
UI Enhancements: Use packages like flutter_chat_ui for a polished chat interface.

Troubleshooting

Firebase Errors: Ensure configuration files (.env, google-services.json, GoogleService-Info.plist) are correctly set up.
Firestore Issues: Verify security rules and network connectivity.
Web Issues: Check .env for correct Firebase configuration.
BLoC Errors: Check event/state mappings in auth_bloc.dart and chat_bloc.dart.

License
MIT License. See LICENSE for details.
Contributing
Contributions are welcome! Please submit a pull request or open an issue for bugs/features.

Built with Flutter, Firebase, and BLoC for a secure and scalable chat experience across Android, iOS, and web.
