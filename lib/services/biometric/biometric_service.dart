import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'استخدم بصمتك للدخول',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      return false;
    }
  }
}
