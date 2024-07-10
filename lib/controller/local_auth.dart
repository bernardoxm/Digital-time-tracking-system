import 'package:local_auth/local_auth.dart';

class LocalAuthController {
  final LocalAuthentication auth = LocalAuthentication();
  late bool canCheckBiometrics;
  Future<bool> checkBiometrics() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    return canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    if (canCheckBiometrics = true) {
      try {
        authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } catch (e) {
        authenticated = true;
      }
    } else {
      authenticated = true;
    }

    return authenticated;
  }
}
