import 'package:flutter_test/flutter_test.dart';

import 'package:gamyeong_exam/main.dart';

void main() {
  testWidgets('홈 화면에 과목 목록이 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const GamyeongExamApp());

    expect(find.text('경제법'), findsOneWidget);
    expect(find.text('민법'), findsOneWidget);
    expect(find.text('경영학'), findsOneWidget);
  });
}
