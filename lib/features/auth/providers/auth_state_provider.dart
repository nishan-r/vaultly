import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

/// Tracks whether the vault is unlocked for this session.
///
/// The vault starts locked. After successful biometric or PIN authentication
/// the provider is set to `true`. A lock event (e.g. app backgrounded beyond
/// timeout, manual lock) sets it back to `false`.
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  bool build() => false; // locked by default

  /// Call after a successful local_auth check.
  void unlock() => state = true;

  /// Call to re-lock the vault.
  void lock() => state = false;
}
