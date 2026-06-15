import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quit_count_flutter/app/quit_count_app.dart';

void main() {
  testWidgets('Phase 1 home preview renders core prototype signals',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const QuitCountApp());

    expect(find.text('戒烟有数'), findsOneWidget);
    expect(find.text('肺部负担指数'), findsOneWidget);
    expect(find.text('真实成本 A1 · Flutter Phase 1'), findsOneWidget);
    expect(find.text('真实日耗'), findsOneWidget);
    expect(find.text('健康负债'), findsOneWidget);
    expect(find.text('取出一支'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });
}
