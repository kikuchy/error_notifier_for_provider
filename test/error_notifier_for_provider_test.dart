import 'package:flutter_test/flutter_test.dart';

import 'package:error_notifier_for_provider/error_notifier_for_provider.dart';

class TestNotifier extends Object with ErrorNotifierMixin {
  TestNotifier(this.message);

  final String message;

  void notify() {
    notifyError(message);
  }
}

void main() {
  test("calling listener", () {
    final message = "test message";
    final notifier = TestNotifier(message);

    notifier.addErrorListener((m) {
      expect(m, message);
    });
    notifier.notify();
  });
}
