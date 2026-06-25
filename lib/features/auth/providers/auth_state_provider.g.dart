// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'ea270ae873ce1b43aaac0ba73490b4cfe736c860';

/// Tracks whether the vault is unlocked for this session.
///
/// The vault starts locked. After successful biometric or PIN authentication
/// the provider is set to `true`. A lock event (e.g. app backgrounded beyond
/// timeout, manual lock) sets it back to `false`.
///
/// Copied from [AuthState].
@ProviderFor(AuthState)
final authStateProvider = NotifierProvider<AuthState, bool>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
