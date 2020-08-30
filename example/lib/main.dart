import 'package:error_notifier_for_provider/error_notifier_for_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePageNotifier extends ChangeNotifier with ErrorNotifierMixin {
  bool loading = false;

  void load() async {
    try {
      loading = true;
      notifyListeners();
      await _tryToLoadAndFail();
    } on Exception catch (e) {
      notifyError(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _tryToLoadAndFail() {
    return Future.delayed(
      Duration(seconds: 2),
      () => throw Exception("Error occurs!!!"),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyHomePageNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Error Notifier for Provider Example"),
        ),
        body: ErrorListener<MyHomePageNotifier>(
          onNotify: (context, message) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(message),
              action: SnackBarAction(
                label: "RETRY",
                onPressed: () {
                  context.read<MyHomePageNotifier>().load();
                },
              ),
            ));
          },
          child: Center(
            child: Selector<MyHomePageNotifier, bool>(
              selector: (context, notifier) => notifier.loading,
              builder: (context, loading, _) {
                if (loading) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        child: Text("LOAD"),
                        onPressed: () {
                          context.read<MyHomePageNotifier>().load();
                        },
                      ),
                      Text("Loading will fail after 2 seconds 😢"),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
