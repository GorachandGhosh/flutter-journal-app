import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myjournalapp/service/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
