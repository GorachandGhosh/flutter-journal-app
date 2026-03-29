import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myjournalapp/providers/auth_provider.dart';
import 'package:myjournalapp/screens/journal_home_screen.dart';
import 'package:myjournalapp/screens/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) =>
          user != null ? const JournalHomeScreen() : const LoginScreen(),
      error: (er, stack) =>
          Scaffold(body: Center(child: Text("Something went wrong: $er"))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
