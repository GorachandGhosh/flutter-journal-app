import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myjournalapp/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceException implements Exception {
  final String message;

  const AuthServiceException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService(this.ref);

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserState(true);
      return result;
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(_mapSignInError(e));
    } on FirebaseException catch (_) {
      throw const AuthServiceException(
        'A Firebase error occurred while signing in. Please try again.',
      );
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      throw AuthServiceException('Login failed. Please try again.');
    }
  }

  Future<UserCredential?> createUser(
    String userName,
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _addUserToDatabase(userName, email, result.user?.uid);
      await _auth.signOut();
      await _saveUserState(false);
      return result;
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(_mapCreateUserError(e));
    } on FirebaseException catch (_) {
      throw const AuthServiceException(
        'A Firebase error occurred while creating your account. Please try again.',
      );
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      throw AuthServiceException('Registration failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _saveUserState(false);
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(_mapSignOutError(e));
    } on FirebaseException catch (_) {
      throw const AuthServiceException(
        'A Firebase error occurred while signing out. Please try again.',
      );
    } catch (e) {
      throw AuthServiceException('Sign out failed. Please try again.');
    }
  }

  Future<void> _addUserToDatabase(
    String userName,
    String email,
    String? uid,
  ) async {
    final user = UserModel(username: userName, email: email);
    try {
      final users = _firestore.collection('users');
      if (uid != null && uid.isNotEmpty) {
        await users.doc(uid).set(user.toMap());
      } else {
        await users.add(user.toMap());
      }
    } on FirebaseException catch (e) {
      throw AuthServiceException(_mapFirestoreError(e));
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      throw AuthServiceException('Failed to save user details. Please try again.');
    }
  }

  Future<void> _saveUserState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> _getUserState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  String _mapSignInError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found. Please register first.';
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-email':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return e.message ?? 'Unable to login right now. Please try again.';
    }
  }

  String _mapCreateUserError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'User already exists. Please login.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'operation-not-allowed':
        return 'Email/password sign up is not enabled right now.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return e.message ?? 'Unable to register right now. Please try again.';
    }
  }

  String _mapSignOutError(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        return e.message ?? 'Unable to sign out right now. Please try again.';
    }
  }

  String _mapFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to save user details.';
      case 'unavailable':
        return 'Service is temporarily unavailable. Please try again.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return e.message ?? 'Unable to save user details right now. Please try again.';
    }
  }
}
