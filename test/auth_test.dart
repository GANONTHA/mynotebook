import 'package:mynotebook/services/auth/auth_exception.dart';
import 'package:mynotebook/services/auth/auth_user.dart';
import 'package:mynotebook/services/auth_provider.dart';
import 'package:test/test.dart';

void main() {
  group(' Mock Authentification', () {
    final provider = MockAuthProvider();

    //testing the user is not initialized
    test('Should not be initialize to begin with', () {
      expect(provider._isInitialized, false);
    });
    //testing the user is initialized
    test('Cannot log Out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
//testing provider Initialization
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    //testing the user to be null upon initialization
    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });
//Testing time required
    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(
          provider.isInitialized,
          true,
        );
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
//testing the user is created

    test('Create user should delegate LogIn', () async {
      final badImailUser =
          provider.createUser(email: "foo@bar.com", password: 'fejerfe');
      expect(badImailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'some@gmail.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
//testing Email Verification
    test('Login User should be able to send email verification', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
//testing logging out and in again

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.login(email: "email", password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'fooo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobaz') throw WrongPasswordAuthException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false,
      email: 'email',
    );
    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'example@gmail.com',
    );
    _user = newUser;
  }
}
