import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Repository for handling authentication operations
class AuthRepository {
  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Secure storage instance (not used on web)
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Stream for monitoring authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up a new user with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null && !kIsWeb) {
        // Store user token securely (non-web only)
        String? token = await user.getIdToken();
        await _storage.write(key: 'user_token', value: token);
      }
      return user;
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }

  // Sign in an existing user with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null && !kIsWeb) {
        // Store user token securely (non-web only)
        String? token = await user.getIdToken();
        await _storage.write(key: 'user_token', value: token);
      }
      return user;
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    if (!kIsWeb) {
      // Remove token from secure storage (non-web only)
      await _storage.delete(key: 'user_token');
    }
    await _auth.signOut();
  }

  // Retrieve stored user token (non-web only)
  Future<String?> getToken() async {
    if (!kIsWeb) {
      return await _storage.read(key: 'user_token');
    }
    return null;
  }
}
