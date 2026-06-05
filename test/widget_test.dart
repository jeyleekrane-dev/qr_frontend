import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_frontend/main.dart';

void main() {
  testWidgets('shows splash screen on startup', (tester) async {
    dotenv.loadFromString(envString: 'API_BASE_URL=http://localhost');

    await tester.pumpWidget(const ProviderScope(child: ULearningApp()));

    expect(find.text('uLearning'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
  });
}
