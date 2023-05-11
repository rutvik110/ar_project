import 'package:collegearproject/dashboard.dart';
import 'package:collegearproject/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewWrapper extends ConsumerWidget {
  const AuthViewWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(streamLogInStatus);
    return authState.when(
      data: (user) {
        if (user == null) {
          // ignore: prefer_const_constructors
          return SignInDialog();
        }
        return const Dashboard();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Error')),
    );
  }
}

class SignInDialog extends ConsumerWidget {
  const SignInDialog({
    super.key,
    this.isPurchaseSignIn = false,
  });

  final bool isPurchaseSignIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final googleUser = await GoogleSignIn().signIn();
                    if (googleUser == null) return;

                    // Obtain the auth details from the request
                    final googleAuth = await googleUser.authentication;

                    // Create a new credential
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );

                    // Once signed in, return the UserCredential
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                  },
                  child: const Text("Sign in with Google")),
              OAuthProviderButton(
                // or any other OAuthProvider
                provider: GoogleProvider(clientId: ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
