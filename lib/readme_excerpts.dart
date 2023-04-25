

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'package:local_auth/local_auth.dart';

import 'package:local_auth_android/local_auth_android.dart' show AndroidAuthMessages, AuthMessages, AuthenticationOptions, BiometricType;

import 'package:local_auth_ios/local_auth_ios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final LocalAuthentication auth = LocalAuthentication();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('README example app'),
        ),
        body: const Text('See example in main.dart'),
      ),
    );
  }

  Future<void> checkSupport() async {

    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    print('Can authenticate: $canAuthenticate');
    print('Can authenticate with biometrics: $canAuthenticateWithBiometrics');
  }

  Future<void> getEnrolledBiometrics() async {
    final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {


    }

  }

  Future<void> authenticate() async {

    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance');
      print(didAuthenticate);

    } on PlatformException {
      // ...
    }

  }

  Future<void> authenticateWithBiometrics() async {

    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(biometricOnly: true));

    print(didAuthenticate);
  }

  Future<void> authenticateWithoutDialogs() async {

    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false));

      print(didAuthenticate ? 'Success!' : 'Failure');

    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {

      } else if (e.code == auth_error.notEnrolled) {
        // ...
      } else {
        // ...
      }
    }

  }

  Future<void> authenticateWithErrorHandling() async {

    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false));

      print(didAuthenticate ? 'Success!' : 'Failure');

    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {

      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      } else {
        // ...
      }
    }

  }

  Future<void> authenticateWithCustomDialogMessages() async {
    // #docregion CustomMessages
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ]);
    // #enddocregion CustomMessages
    print(didAuthenticate ? 'Success!' : 'Failure');
  }
}