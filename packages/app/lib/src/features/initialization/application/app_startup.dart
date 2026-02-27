import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangabackupconverter/src/features/initialization/application/info_service.dart';
import 'package:mangabackupconverter/src/features/settings/application/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_manager/window_manager.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  ref.onDispose(() {
    // invalidate all the providers we depend on
    ref.invalidate(prefsProvider);
    ref.invalidate(packageInfoProvider);
  });
  // all asynchronous app initialization code should belong here:
  await (
    _initWindow(),
    ref.watch(prefsProvider.future),
    ref.watch(packageInfoProvider.future),
  ).wait;
}

Future<void> _initWindow() async {
  if (!kIsWeb &&
      (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(390, 150));
  }
}
