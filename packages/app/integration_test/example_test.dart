import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mangabackupconverter/app.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to home and going back',
    skip: true,
    (PatrolIntegrationTester $) async {
      await $.pumpWidgetAndSettle(const ProviderScope(child: App()));

      await $(FloatingActionButton).tap();
      expect($(#counterText).text, '1');

      await $.platformAutomator.android.pressHome();
      await $.platformAutomator.android.pressDoubleRecentApps();

      expect($(#counterText).text, '1');
      await $(FloatingActionButton).tap();
      expect($(#counterText).text, '2');

      await $.platformAutomator.android.openNotifications();
      await $.platformAutomator.android.pressBack();
    },
  );
}
