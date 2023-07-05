import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

int? pages;
bool isReady = true;
PDFViewController? _controller;
String? intentData;

void main() {
  runApp(const MyApp());
}

class MyPlugin {
  static const MethodChannel _channel = MethodChannel('AttendanceAbsent');

  static Future<String> getIntentData() async {
    final String intentDatas =
        await _channel.invokeMethod('getIntentData') ?? "Null";
    return intentDatas;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> hahaha() async {
    var test = await MyPlugin.getIntentData();
    setState(() {
      intentData = test;
    });
  }

  @override
  void initState() {
    super.initState();
    hahaha();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter PDF View')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Loading"),
        ),
        body: Center(
          child: CircularProgressIndicator()
        ),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (intentData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              Text(intentData ?? "gak ada"),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      print(intentData);
                    });
                  },
                  child: Text("ok"))
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: PDFView(
            filePath: intentData,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              setState(() {
                _controller = pdfViewController;
              });
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                pages = page;
              });
            },
          ),
        ),// This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
}
