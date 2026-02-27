@TestOn('vm')
@Tags(<String>['presubmit-only'])
@Timeout(Duration(seconds: 120))
library;

import 'package:build_verify/build_verify.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(
    'ensure_gen',
    () => expectBuildClean(packageRelativeDirectory: 'packages/mangabackupconverter_cli'),
    // Skipped because build_verify package does not support flutter gen-l10n.
    skip: false,
  );
}
