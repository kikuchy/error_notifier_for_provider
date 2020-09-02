# error_notifier_for_provider

A trick to notify errors in ChangeNotifier/ValueNotifier/StateNotifier.
No more `GlobalKey<Scaffold>`!

```dart
Provider(
  create (_) => YourObjectWithErrorNotifierMixin(),
  child: Scaffold(
    body: ErrorListener(
      onNotify: (context, message) => Scaffold.of(context).showSnackbar(
        Snackbar(content: Text(message))
      )
      child: YourContent(),
    ),
  ),
);
```

## Pros

* Easy to use
* You can use it with ChangeNotifier/ValueNotifier/StateNotifier and any other provided objects.


## Motivation

ChangeNotifier/ValueNotifier/StateNotifier can notify and reflect its state to other object.
But it's for UI, not the one shot notification like an error notification.

`error_notifier_for_provider` provides another path to notify something.
