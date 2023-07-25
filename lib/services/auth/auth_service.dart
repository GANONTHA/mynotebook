import 'package:mynotebook/services/auth/firebase_auth_provider.dart';
import 'package:mynotebook/services/auth/auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() async => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    provider.sendPasswordReset(toEmail: toEmail);
  }
}
