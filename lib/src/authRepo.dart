import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:padhaihub/src/notificationRepo.dart';
import 'package:padhaihub/src/src.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheManager? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    required NotificationRepository notificationRepository,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? DefaultCacheManager(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _notificationRepository = notificationRepository,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheManager _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final NotificationRepository _notificationRepository;
  final GoogleSignIn _googleSignIn;
  
  @visibleForTesting
  bool isWeb = kIsWeb;
  
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [UserModel] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [UserModel.empty] if the user is not authenticated.

  Future<File> _saveToCache(UserModel user) {
    return _cache.putFile("auth_result", Uint8List.fromList(utf8.encode(jsonEncode({userCacheKey: user.toJSON()}))));
  }

  Future<void> createChatUser(UserModel user) async {
    if (await FirebaseChatCore.instance.checkIfExists(user.id)) {
      FirebaseChatCore.instance.updateLastSeen(user.id);
    } else {
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
            firstName: user.name,
            id: user.id, // UID from Firebase Authentication
            imageUrl: user.photo,
            metadata: {
              "id": user.email?.split("@")[0],
              "files_shared": 0
            }
        ),
      );
      _notificationRepository.setTokenForUser(user.id);
    }
  }

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUserModel;
      if (firebaseUser != null) {
        _notificationRepository.setTokenForUser(user.id);
        createChatUser(user);
      }
      _saveToCache(user);
      // _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [UserModel.empty] if there is no cached user.
  Future<UserModel> get currentUser async {
    final res = await _cache.getFileFromCache("auth_result");
    final data = await res?.file.readAsString();
    if (data == null) {
      return UserModel.empty;
    } else {
      return UserModel.fromJSON(jsonDecode(data)[userCacheKey]);
    }
    // return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }


  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
      if (_firebaseAuth.currentUser != null) {
        if (!((_firebaseAuth.currentUser?.email!.endsWith("@hyderabad.bits-pilani.ac.in") ?? false) || _firebaseAuth.currentUser?.email == "pratyushsunil@gmail.com")) {
          await logOut();
          showToastMessage("You're only allowed to log in with your BITS email.");
          throw const LogInWithGoogleFailure("You're only allowed to log in with your BITS email.");
        } else {
          _notificationRepository.setTokenForUser(_firebaseAuth.currentUser!.uid);
        }
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _notificationRepository.removeTokenFromUser(_firebaseAuth.currentUser!.uid),
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _saveToCache(UserModel.empty),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [UserModel].
  UserModel get toUserModel {
    return UserModel(id: uid, email: email, name: displayName, photo: photoURL);
  }
}