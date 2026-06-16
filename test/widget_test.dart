import 'package:flutter_test/flutter_test.dart';

import 'package:hewanku_mobile/main.dart';

void main() {
  testWidgets('App menampilkan onboarding saat belum ada session', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('HewanKu'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
