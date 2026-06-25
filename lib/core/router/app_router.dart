import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/lock_screen.dart';
import '../../features/auth/providers/auth_state_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isUnlocked = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/lock',
    redirect: (context, state) {
      final goingToLock = state.matchedLocation == '/lock';

      if (!isUnlocked && !goingToLock) return '/lock';
      if (isUnlocked && goingToLock) return '/vault';
      return null;
    },
    routes: [
      GoRoute(
        path: '/lock',
        name: 'lock',
        builder: (context, state) => const LockScreen(),
      ),
      // Placeholder for the vault home – will be replaced in next phase.
      GoRoute(
        path: '/vault',
        name: 'vault',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Vault Home – coming next')),
        ),
      ),
    ],
  );
});
