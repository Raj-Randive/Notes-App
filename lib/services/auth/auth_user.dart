import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// Immutable class here means that this class or any subclass of this class are gonna be immutable meaning their internals are never gonna change upon initialisation

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(user.emailVerified);
  }
}
