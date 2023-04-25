import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
        _supportState = isSupported;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Biometrics Authentication'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_supportState)
            const Text('This device is supported')
          else
            const Text('This device is not supported'),
          const Divider(height: 100),
          ElevatedButton(
            onPressed: _getAvailableBiometrics,
            child: const Text('Get available biometrics'),
          ),
          const Divider(height: 100),
          ElevatedButton(
            onPressed: _authenticate,
            child: const Text('Authenticate'),
          )
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan  to authenticate',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _supportState = authenticated;
    });
  }

  void _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    if (kDebugMode) {
      print("List of availableBiometrics : $availableBiometrics");
    }

    if (!mounted) {
      return;
    }
  }
}
