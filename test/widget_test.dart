import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quit_count_flutter/app/quit_count_app.dart';

void main() {
  testWidgets('latest simplified home renders prototype actions',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const QuitCountApp());

    expect(find.text('戒烟有数'), findsOneWidget);
    expect(find.text('今日危害评分'), findsOneWidget);
    expect(find.text('库存 17 支 · 今日 4/5 支'), findsOneWidget);
    expect(find.text('真实日耗'), findsOneWidget);
    expect(find.text('健康净值'), findsOneWidget);
    expect(find.text('健康负债'), findsOneWidget);
    expect(find.text('7 日危害趋势'), findsOneWidget);
    expect(find.text('稳定'), findsOneWidget);
    expect(find.text('放回库存'), findsOneWidget);
    expect(find.text('取出一支'), findsOneWidget);
    expect(find.text('查看资产'), findsNothing);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });

  testWidgets('take sheet keeps optional note visible and writes ledger',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const QuitCountApp());

    await tester.tap(find.text('取出一支'));
    await tester.pumpAndSettle();

    expect(find.text('记录取出'), findsWidgets);
    expect(find.text('补充备注（选填）'), findsOneWidget);
    expect(find.textContaining('触发严厉警示时会连发手机通知栏提醒'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '饭后');
    await tester.tap(find.widgetWithText(FilledButton, '记录取出'));
    await tester.pumpAndSettle();

    expect(find.text('库存 16 支 · 今日 5/5 支'), findsOneWidget);
  });
}
