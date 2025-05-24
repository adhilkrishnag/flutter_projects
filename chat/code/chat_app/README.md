Chat App
A Flutter-based chat application using Firebase for authentication and real-time messaging, with secure storage for user tokens (non-web). The app leverages the BLoC pattern with a feature-first architecture for reactive state management. It supports Android, iOS, and web platforms.
Features

Authentication: Sign up and sign in with email/password using Firebase Authentication.
Real-Time Chat: Send and receive messages in real-time via Firestore.
Secure Storage: Store user tokens securely using flutter_secure_storage (Android/iOS only).
BLoC Pattern: Reactive state management for authentication and chat using flutter_bloc.
Dependency Injection: Manage dependencies with get_it for scalability.
Responsive UI: Clean login and chat screens with error feedback via SnackBar.
Error Handling: Robust validation for Firestore data, with SnackBar feedback for missing messages.
Cross-Platform: Optimized for Android, iOS, and web.

Prerequisites

Flutter SDK: Version 3.0.0 or higher.
Firebase Account: Required for Authentication and Firestore.
IDE: Android Studio, VS Code, or any Flutter-compatible IDE.
Dart Packages: Listed in pubspec.yaml.
Web Browser: Chrome for testing web app.

Setup Instructions
1. Clone the Repository
git clone https://github.com/adhilkrishnag/flutter_projects/tree/main/chat/code/chat_app
cd chat_app

2. Configure Firebase

Create a Firebase project in the Firebase Console.
Enable Email/Password Authentication:
Go to Authentication > Sign-in method > Enable Email/Password provider.


Enable Firestore:
Go to Firestore Database > Create database (start in production mode).


Add Apps to Firebase Project (Project Settings > General > Your apps):
Android:
Package name: com.example.chat_app
Download google-services.json and place in android/app/.


iOS:
Bundle ID: com.example.chatApp
Download GoogleService-Info.plist and place in ios/Runner/.


Web:
Register a web app and copy Firebase configuration.
Create a .env file in the project root:FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your-messaging-sender-id
FIREBASE_APP_ID=your-app-id






Apply Firestore Security Rules:
In Firebase Console > Firestore Database > Rules, set:rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /messages/{messageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
                   && request.resource.data.senderId is string
                   && request.resource.data.senderId != ''
                   && request.resource.data.content is string
                   && request.resource.data.content != ''
                   && request.resource.data.timestamp is timestamp;
    }
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}


Click Publish.



3. Install Dependencies
Update pubspec.yaml with:
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  flutter_secure_storage: ^9.2.2
  flutter_bloc: ^9.0.1
  equatable: ^2.0.5
  flutter_dotenv: ^5.1.0
  get_it: ^7.7.0
  dartz: ^0.10.1
  flex_seed scheme

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

Run:
flutter pub get

4. Update Platform Configurations

Android:
In android/app/src/main/AndroidManifest.xml:<application
    android:label="Chat App"
    ...>


Ensure google-services.json is in android/app/.
Update android/build.gradle:classpath 'com.google.gms:google-services:4.4.2'


Update android/app/build.gradle:apply plugin: 'com.google.gms.google-services'




iOS:
In ios/Runner/Info.plist:<key>CFBundleName</key>
<string>Chat App</string>


Ensure GoogleService-Info.plist is in ios/Runner/.


Web:
Ensure .env is configured with Firebase credentials.
Verify web/index.html includes Firebase SDK:<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-firestore.js"></script>





5. Enable Web Support
Ensure Flutter web is enabled:
flutter config --enable-web

Verify web support:
flutter devices

You should see a browser (e.g., Chrome) listed.
6. Run the App

Android/iOS:
Connect a device/emulator.
Run:flutter run




Web:
Run:flutter run -d chrome





7. Project Structure
lib/
├── core/
│   ├── di/                   # Dependency injection
│   │   ├── injection.dart
│   ├── error/                # Error handling
│   │   ├── exceptions.dart
│   │   ├── failures.dart
├── src/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── bloc/         # Authentication BLoC
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   ├── auth_state.dart
│   │   │   ├── data/         # Auth data sources and repositories
│   │   │   │   ├── firebase_auth_data_source.dart
│   │   │   │   ├── auth_repository_impl.dart
│   │   │   ├── domain/       # Auth entities and use cases
│   │   │   │   ├── user.dart
│   │   │   │   ├── sign_in.dart
│   │   │   │   ├── sign_up.dart
│   │   │   │   ├── sign_out.dart
│   │   │   ├── presentation/ # Auth UI
│   │   │   │   ├── auth_wrapper.dart
│   │   │   │   ├── login_screen.dart
│   │   ├── chat/
│   │   │   ├── bloc/         # Chat BLoC
│   │   │   │   ├── chat_bloc.dart
│   │   │   │   ├── chat_event.dart
│   │   │   │   ├── chat_state.dart
│   │   │   ├── data/         # Chat data sources and repositories
│   │   │   │   ├── firebase_chat_data_source.dart
│   │   │   │   ├── chat_repository_impl.dart
│   │   │   ├── domain/       # Chat entities and use cases
│   │   │   │   ├── message.dart
│   │   │   │   ├── send_message.dart
│   │   │   │   ├── get_messages.dart
│   │   │   ├── presentation/ # Chat UI
│   │   │   │   ├── chat_screen.dart
├── main.dart                 # App entry point
web/
├── index.html                # Firebase SDK for web

Usage

Login Screen:
Enter email (e.g., test@example.com) and password (e.g., Password123!) to sign in or sign up.
Toggle between sign-in/sign-up modes via a text button.
Errors (e.g., invalid credentials) are shown via SnackBar.


Chat Screen:
Displays real-time messages from all users, aligned right (self) or left (others).
Send messages using the text field and send button.
Shows timestamps and handles invalid data with a SnackBar (e.g., “Some messages may be missing”).
Sign out via the AppBar logout button.



Security Features

Firestore Rules: Enforce non-empty senderId and content for messages; only authenticated users can read/write.
Secure Storage: User tokens stored securely on Android/iOS using flutter_secure_storage; web uses Firebase Authentication.
Input Validation: Non-empty email, password, and message content enforced client-side.
Environment Variables: Firebase keys stored in .env, excluded from version control.
Data Validation: Null checks in Firestore data processing to prevent crashes.

Troubleshooting

Firebase Errors:
Verify .env, google-services.json, and GoogleService-Info.plist are correctly configured.
Check Firebase Console for project ID (chat-app-new-12345) and credentials.


Firestore Issues:
Ensure security rules are applied and network is stable.
Invalid Documents: If logs show “Skipping invalid document” (e.g., content=null), clean the messages collection:
In Firebase Console > Firestore > messages, delete documents with null or empty content (e.g., IDs sqXDQCpwCoCcbqXlXFmS, xy53KiOQYKzYcrnGcPT7).
After cleanup, verify no “Skipping invalid document” logs in Chrome DevTools > Console.




Web Issues:
Ensure .env has correct Firebase web credentials.
Check Chrome DevTools > Console for errors.


BLoC Errors:
Verify event/state mappings in auth_bloc.dart and chat_bloc.dart.
Check get_it registrations in core/di/injection.dart.



Testing

Unit Tests: Add tests for AuthBloc and ChatBloc using flutter_test.
Integration Tests: Test Firestore streams with fake_cloud_firestore.
Example Test:import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:chat_app/src/features/chat/data/firebase_chat_data_source.dart';

void main() {
  late FirebaseChatDataSource dataSource;
  late FakeFirebaseFirestore firestore;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    dataSource = FirebaseChatDataSource().._firestore = firestore;
  });

  test('getMessages skips invalid documents', () async {
    await firestore.collection('messages').doc('invalid').set({
      'senderId': 'user1',
      'content': null,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await firestore.collection('messages').doc('valid').set({
      'senderId': 'user2',
      'content': 'Hello',
      'timestamp': FieldValue.serverTimestamp(),
    });

    final messages = await dataSource.getMessages().first;
    expect(messages.length, 1);
    expect(messages[0].content, 'Hello');
  });
}



License
MIT License. See LICENSE for details.
Contributing
Contributions are welcome! Please submit a pull request or open an issue for bugs/features.
Built with Flutter, Firebase, and BLoC for a secure, scalable chat experience across Android, iOS, and web.
