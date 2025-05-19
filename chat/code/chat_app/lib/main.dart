import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/auth_repository.dart';
import 'screens/auth_wrapper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  try {
    if (kIsWeb) {
      final apiKey = dotenv.env['FIREBASE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('Error: FIREBASE_API_KEY is missing in .env');
        throw Exception('Missing Firebase configuration');
      }
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey,
          authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
          projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
          storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
          messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
          appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Optionally show an error UI
    runApp(MaterialApp(
        home: Scaffold(
            body: Center(child: Text('Failed to initialize app: $e')))));
    return;
  }

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(AuthStarted()),
        child: MaterialApp(
          title: 'Chat App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}
