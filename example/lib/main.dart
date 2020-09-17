import 'package:flutter/material.dart';
import 'package:icnh_logger/icnh_logger.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icnh Logger Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showLog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      log.debug('This is a debug message!');
                    },
                    child: Text('Log Debug'),
                  ),
                  MaterialButton(
                    color: Colors.yellow,
                    onPressed: () {
                      log.warn('This is a warning!');
                    },
                    child: Text('Log Warning'),
                  ),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      log.error('This is an error!');
                    },
                    child: Text('Log Error'),
                  ),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      throw UnimplementedError('Example error');
                    },
                    child: Text('Throw Error'),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () => setState(() => _showLog = true),
                    child: Text('SHOW LOG'),
                  ),
                ],
              ),
            ),
          ),
          if (_showLog)
            SafeArea(
              child: LogView(
                onClose: () => setState(() => _showLog = false),
              ),
            ),
        ],
      ),
    );
  }
}
