
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/lock_screen.dart';
import '../../features/auth/providers/auth_state_provider.dart';
import '../../features/entry/presentation/main_screen.dart';
import '../../features/group/presentation/group_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/vault/presentation/vault_screen.dart';

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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vault',
                name: 'vault',
                builder: (context, state) => const VaultScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/groups',
                name: 'groups',
                builder: (context, state) => const GroupScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
