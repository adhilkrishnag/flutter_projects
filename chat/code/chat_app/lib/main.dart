import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/auth_repository.dart';
import 'screens/auth_wrapper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with platform-specific options
  if (kIsWeb) {
    // Web-specific Firebase initialization using environment variables
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      ),
    );
  } else {
    // Android/iOS Firebase initialization using google-services.json or GoogleService-Info.plist
    await Firebase.initializeApp();
  }

  runApp(const ChatApp());
}

// Main application widget
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // Provide AuthRepository to the widget tree
      create: (context) => AuthRepository(),
      child: BlocProvider(
        // Initialize AuthBloc and trigger AuthStarted event
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(AuthStarted()),
        child: MaterialApp(
          title: 'Chat App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Set AuthWrapper as the home screen
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}