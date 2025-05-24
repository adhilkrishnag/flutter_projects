Chat App 💬
A Flutter-based chat application powered by Firebase for authentication and real-time messaging, with secure token storage for non-web platforms. Built with a feature-first architecture and the BLoC pattern, it ensures reactive state management and supports Android, iOS, and web platforms.
✨ Features

Authentication: Secure email/password sign-up and sign-in with Firebase Authentication.
Real-Time Chat: Send and receive messages instantly via Firestore.
Secure Storage: Store user tokens safely using flutter_secure_storage (Android/iOS only).
BLoC Pattern: Manage state reactively with flutter_bloc for authentication and chat.
Dependency Injection: Scalable dependency management with get_it.
Responsive UI: Intuitive login and chat interfaces with SnackBar error feedback.
Error Handling: Robust Firestore data validation, alerting users to missing messages.
Cross-Platform: Optimized for Android, iOS, and web.

📋 Prerequisites

Flutter SDK: Version 3.0.0 or higher
Firebase Account: For Authentication and Firestore
IDE: Android Studio, VS Code, or any Flutter-compatible IDE
Dart Packages: Specified in pubspec.yaml
Web Browser: Chrome for web app testing

🚀 Setup Instructions
1. Clone the Repository
git clone https://github.com/adhilkrishnag/flutter_projects/tree/main/chat/code/chat_app
cd chat_app

2. Configure Firebase 🔥

Create a Firebase project in the Firebase Console.
Enable Email/Password Authentication:
Navigate to Authentication > Sign-in method.
Enable the Email/Password provider.


Enable Firestore:
Go to Firestore Database > Create database (select production mode).


Add Apps to Firebase Project:
Android:
Package name: com.example.chat_app
Download google-services.json to android/app/.


iOS:
Bundle ID: com.example.chatApp
Download GoogleService-Info.plist to ios/Runner/.


Web:
Register a web app and copy Firebase configuration.

Create a .env file in the project root:
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your-messaging-sender-id
FIREBASE_APP_ID=your-app-id






Apply Firestore Security Rules:
In Firebase Console > Firestore Database > Rules, set:
rules_version = '2';
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




3. Install Dependencies 📦
Update pubspec.yaml:



Package
Version



flutter
SDK


firebase_core
^3.6.0


firebase_auth
^5.3.1


cloud_firestore
^5.4.4


flutter_secure_storage
^9.2.2


flutter_bloc
^9.0.1


equatable
^2.0.5


flutter_dotenv
^5.1.0


get_it
^7.7.0


dartz
^0.10.1


flex_color_scheme
^8.2.0


flutter_test (dev)
SDK


flutter_lints (dev)
^4.0.0


Run:
flutter pub get

4. Update Platform Configurations ⚙️

Android:
In android/app/src/main/AndroidManifest.xml:
<application
    android:label="Chat App"
    ...>


Place google-services.json in android/app/.

Update android/build.gradle:
classpath 'com.google.gms:google-services:4.4.2'


Update android/app/build.gradle:
apply plugin: 'com.google.gms.google-services'




iOS:
In ios/Runner/Info.plist:
<key>CFBundleName</key>
<string>Chat App</string>


Place GoogleService-Info.plist in ios/Runner/.



Web:
Ensure .env has Firebase credentials.

Verify web/index.html includes Firebase SDK:
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-firestore.js"></script>





5. Enable Web Support 🌐
Enable Flutter web:
flutter config --enable-web

Verify:
flutter devices

Ensure a browser (e.g., Chrome) is listed.
6. Run the App 🏃

Android/iOS:
Connect a device/emulator.

Run:
flutter run




Web:
Run:
flutter run -d chrome





7. Project Structure 📂



Path
Description



lib/core/di/injection.dart
Dependency injection setup


lib/core/error/
Error handling (exceptions, failures)


lib/src/features/auth/
Authentication feature


lib/src/features/auth/bloc/
Auth BLoC (events, states, bloc)


lib/src/features/auth/data/
Auth data sources, repositories


lib/src/features/auth/domain/
Auth entities, use cases


lib/src/features/auth/presentation/
Auth UI (wrapper, login screen)


lib/src/features/chat/
Chat feature


lib/src/features/chat/bloc/
Chat BLoC (events, states, bloc)


lib/src/features/chat/data/
Chat data sources, repositories


lib/src/features/chat/domain/
Chat entities, use cases


lib/src/features/chat/presentation/
Chat UI (chat screen)


lib/main.dart
App entry point


web/index.html
Firebase SDK for web


🖥️ Usage

Login Screen:
Enter email (e.g., test@example.com) and password (e.g., Password123!).
Toggle sign-in/sign-up modes via a text button.
View errors (e.g., invalid credentials) via SnackBar.


Chat Screen:
See real-time messages, aligned right (self) or left (others).
Send messages using the text field and send button.
View timestamps; invalid data triggers a SnackBar (e.g., “Some messages may be missing”).
Sign out via the AppBar logout button.



🔒 Security Features

Firestore Rules: Enforce non-empty senderId and content; only authenticated users can read/write.
Secure Storage: Tokens stored securely on Android/iOS; web uses Firebase Authentication.
Input Validation: Non-empty email, password, and message content enforced.
Environment Variables: Firebase keys in .env, excluded from version control.
Data Validation: Null checks prevent Firestore-related crashes.

🛠️ Troubleshooting

Firebase Errors:
Verify .env, google-services.json, and GoogleService-Info.plist configurations.
Check Firebase Console for project ID (chat-app-new-12345) and credentials.


Firestore Issues:
Ensure security rules are applied and network is stable.


Web Issues:
Ensure .env has correct Firebase web credentials.
Check Chrome DevTools > Console for errors.


BLoC Errors:
Verify event/state mappings in auth_bloc.dart and chat_bloc.dart.
Check get_it registrations in core/di/injection.dart.



🧪 Testing

Unit Tests: Test AuthBloc and ChatBloc with flutter_test.

Integration Tests: Test Firestore streams with fake_cloud_firestore.

Example Test:
import 'package:flutter_test/flutter_test.dart';
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



📜 License
MIT License. See LICENSE for details.
🤝 Contributing
Contributions are welcome! Submit a pull request or open an issue for bugs or features.
Built with Flutter, Firebase, and BLoC for a secure, scalable chat experience across Android, iOS, and web.
