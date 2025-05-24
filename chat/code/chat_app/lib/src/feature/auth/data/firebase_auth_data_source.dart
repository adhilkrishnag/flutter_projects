import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../core/error/exceptions.dart';
import '../domain/user.dart';

class FirebaseAuthDataSource {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;

  Future<User> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw ServerException('User not found');
      }
      return User(id: firebaseUser.uid, email: firebaseUser.email ?? '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<User> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw ServerException('User creation failed');
      }
      return User(id: firebaseUser.uid, email: firebaseUser.email ?? '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;
      return User(id: firebaseUser.uid, email: firebaseUser.email ?? '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}