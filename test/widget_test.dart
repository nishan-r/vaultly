import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vaultly/main.dart';

void main() {
  testWidgets('Lock screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: VaultlyApp()),
    );
    await tester.pump();

    // The lock screen should show the heading.
    expect(find.text('Unlock to continue'), findsOneWidget);

    // The Use PIN button should be present.
    expect(find.text('Use PIN'), findsOneWidget);

    // The Vaultly branding should be visible.
    expect(find.text('Vaultly'), findsOneWidget);
  });
}
