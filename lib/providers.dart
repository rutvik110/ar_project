import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final StreamProvider<User?> streamLogInStatus =
    StreamProvider<User?>((StreamProviderRef<User?> ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final sharedPreferancesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
