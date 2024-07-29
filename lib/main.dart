import 'dart:async';
import 'package:flutter/material.dart';
import 'package:verbuildno/verbuildno.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo 1.0.4+2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo 1.0.4+2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _requestCount = 0;
  final _verbuildnoPlugin = Verbuildno();
  String _numberOfCore = "Unknown";
  Timer? _timer;
  String _apiResponse = "No response yet";

  @override
  void initState() {
    super.initState();
    _getNumberOfCore();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getNumberOfCore() async {
    String? core = await _verbuildnoPlugin.getNumberOfCore();
    setState(() {
      _numberOfCore = core ?? "Unknown";
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _requestCount = _requestCount + 1;
      _makeGetRequest();
    });
  }

  Future<void> _makeGetRequest() async {
    try {
      final response = await http.get(
          Uri.parse('https://6242f044d126926d0c59a15f.mockapi.io/userprofile'));
      if (response.statusCode == 200) {
        setState(() {
          _apiResponse = response.body.length <= 200
              ? response.body
              : response.body.substring(0, 200) + '$_requestCount...';
        });
      } else {
        setState(() {
          _apiResponse = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: $e';
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Number Of Core: $_numberOfCore'),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text('API Response: $_apiResponse'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
