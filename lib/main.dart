import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio();

void main() {
  runApp(const MyApp());
}

//create the view model

class MyHomePageViewModel extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  Future<String> getHttp() async {
    final response =
        await dio.get('https://channel.api.nanosoft.co.za/app/campaign/0517/participant/0000002C/registrations');
    return response.data;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple MVVM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'MVVM'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final MyHomePageViewModel _viewModel = MyHomePageViewModel();

  final String title;

  void _incrementCounter() {
    _viewModel.incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Your method here
      var data = await _viewModel.getHttp();
      print(data);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ListenableBuilder(
                listenable: _viewModel,
                builder: (BuildContext context, child) {
                  return Text(
                    '${_viewModel.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
