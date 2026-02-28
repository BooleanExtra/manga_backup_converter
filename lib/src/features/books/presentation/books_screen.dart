import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangabackupconverter/src/routing/router/router.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.blue,
        child: Center(
          child: FilledButton(
            key: const ValueKey<String>('home_settings_button'),
            onPressed: () async {
              context.goNamed(RouteName.settings.name);
            },
            child: const Text('Open Settings'),
          ),
        ),
      ),
    );
  }
}
