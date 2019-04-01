import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(Timetrackr());

class Timetrackr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetrackr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Timetrackr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _tracking = false;
  DateTime _startTime;
  Duration _currentDuration;
  Duration _trackedDuration;
  List<Duration> _history = List<Duration>();

  String _timeDisplay() {
    if (_tracking) {
      return _formatDuration(_currentDuration);
    } else {
      if (_trackedDuration == null) {
        return "Start tracking time!";
      } else {
        return _formatDuration(_trackedDuration);
      }
    }
  }

  void _toggleTracking() {
    setState(() {
      _tracking = !_tracking;
    });
    if (_tracking) {
      _startTime = DateTime.now();
    } else {
      _trackedDuration = _currentDuration;
      _history.add(_trackedDuration);
    }
  }

  void _updateCurrentDuration() {
    if (_tracking && _startTime != null) {
      setState(() {
        _currentDuration = DateTime.now().difference(_startTime);
      });
    }
  }

  String _formatDuration(Duration duration) {
    return duration.toString().substring(0, 7);
  }

  @override
  void initState() {
    _currentDuration = Duration();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateCurrentDuration());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120,
              child: Center(
                child: Text(
                  _timeDisplay(),
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.blueGrey, border: Border(top: BorderSide(color: Theme.of(context).dividerColor))),
                padding: EdgeInsets.only(top: 3),
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      child: ListTile(leading: Icon(Icons.alarm), title: Text(_formatDuration(_history[index]), textAlign: TextAlign.end,))
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTracking,
        tooltip: 'Toggle Tracking',
        child: _tracking ? Icon(Icons.alarm_off) : Icon(Icons.alarm),
        backgroundColor: _tracking ? Colors.red : Colors.blue,
      ),
    );
  }
}
