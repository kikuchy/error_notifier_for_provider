library error_notifier_for_provider;

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Mixin to broadcast errors for outside of the class.
mixin ErrorNotifierMixin {
  Set<ErrorCallback> _callbacks = {};

  /// Register a function to be called when the error occurs.
  ErrorListeningCanceler addErrorListener(ErrorCallback listener) {
    _callbacks.add(listener);
    return () {
      _callbacks.remove(listener);
    };
  }

  /// Call all the registered listeners.
  @protected
  void notifyError(String message) {
    for (final c in _callbacks) {
      c(message);
    }
  }
}

typedef ErrorCallback = void Function(String);
typedef ErrorListeningCanceler = void Function();

/// A widget to use broadcasted errors.
class ErrorListener<T extends ErrorNotifierMixin> extends StatefulWidget {
  const ErrorListener({
    @required this.child,
    @required this.onNotify,
    Key key,
  })  : assert(child != null),
        assert(onNotify != null),
        super(key: key);

  /// A widget to show under this widget.
  final Widget child;

  /// A function catches notified errors.
  /// You can use it for showing error messages for users.
  final void Function(BuildContext context, String message) onNotify;

  @override
  _ErrorListenerState createState() => _ErrorListenerState<T>();
}

class _ErrorListenerState<T extends ErrorNotifierMixin>
    extends State<ErrorListener> {
  ErrorListeningCanceler _cancel;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(ErrorListener<ErrorNotifierMixin> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _listen();
  }

  void _listen() {
    _cancel?.call();
    final notifier = Provider.of<T>(context, listen: false);
    assert(notifier != null);
    _cancel = notifier.addErrorListener(_onNotify);
  }

  void _onNotify(String message) {
    Future(() => widget.onNotify(context, message));
  }

  @override
  void dispose() {
    _cancel?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
