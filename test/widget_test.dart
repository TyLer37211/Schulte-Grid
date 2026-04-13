import 'package:flutter_test/flutter_test.dart';

import 'package:schulte_grid/app/app.dart';

void main() {
  testWidgets('app starts and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const SchulteGridApp());

    expect(find.text('Schulte Grid'), findsOneWidget);
  });
}
