import 'package:flutter_test/flutter_test.dart';
import 'package:memeic/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('OnboardingauthViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
