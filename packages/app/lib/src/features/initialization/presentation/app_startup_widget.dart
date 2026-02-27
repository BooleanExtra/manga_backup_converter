import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mangabackupconverter/src/features/initialization/application/app_startup.dart';

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({required this.onLoaded, super.key});
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> appStartupState = ref.watch(appStartupProvider);
    final Widget widget = onLoaded(context);
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: appStartupState.when(
        // use an external widget builder to decide what to return
        data: (_) => Container(
          key: const ValueKey<String>('appStartupData'),
          child: widget,
        ),
        loading: () => const AppStartupLoadingWidget(
          key: ValueKey<String>('appStartupLoading'),
        ),
        error: (Object e, StackTrace st) => AppStartupErrorWidget(
          key: const ValueKey<String>('appStartupError'),
          message: e.toString(),
          onRetry: () {
            ref.invalidate(appStartupProvider);
          },
        ),
      ),
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            final Brightness brightness = MediaQuery.platformBrightnessOf(
              context,
            );
            return ColoredBox(
              color: brightness == Brightness.dark
                  ? Colors.black87
                  : Colors.white,
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(message, style: Theme.of(context).textTheme.headlineSmall),
              gap16,
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
