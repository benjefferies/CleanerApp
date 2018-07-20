import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayWidget extends StatefulWidget {
  final DateTime day;

  DayWidget({this.day});

  @override
  State<StatefulWidget> createState() => DayState(day: this.day);
}

class DayState extends State<DayWidget> {
  DateTime day;
  DateFormat dateFormat = DateFormat('dd MMMM');

  Map<TimeOfDay, bool> timeOfDaysChecks = new Map();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<TimeOfDay> timeOfDays = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
  ];

  int lastPage = 100;

  DayState({this.day}) {
    timeOfDays.forEach((t) => timeOfDaysChecks[t] = false);
  }

  @override
  Widget build(BuildContext context) {
    String title = dateFormat.format(day);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(title),
        actions: <Widget>[
          // action button
          new IconButton(
            icon: new Icon(Icons.add_circle),
            tooltip: 'Book',
            onPressed: () {
              var message = 'Booked for\n';
              timeOfDaysChecks.forEach((t, b) {
                if (b) {
                  message += '${t.format(context)}\n';
                }
              });
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text(message),
              ));
            },
          ),
        ],
      ),
      body: new Center(
        child: new PageView.builder(
            itemBuilder: (context, index) => createDay(context),
            controller: PageController(initialPage: 100),
            onPageChanged: (i) => this.setState(() {
              var toAdd = i > lastPage ? 1 : -1;
              this.day = this.day.add(Duration(days: toAdd));
              this.lastPage = i;
            })),
      ),
    );
  }

  CheckboxListTile buildCheckboxListTile(
      BuildContext context, TimeOfDay time, bool booked) {
    var text = time.format(context);
    return CheckboxListTile(
      key: Key(text),
      value: timeOfDaysChecks[time],
      onChanged: (b) {
        setState(() {
          timeOfDaysChecks[time] = b;
        });
      },
      secondary: Icon(booked ? Icons.event_busy : Icons.event_available),
      title: Text(text, style: Theme.of(context).textTheme.display1),
    );
  }

  ListView createDay(BuildContext context) {
    List<Widget> widgets = [];
    timeOfDaysChecks.forEach((t, b) {
      widgets.add(buildCheckboxListTile(context, t, b));
      widgets.add(Divider());
    });
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: widgets,
    );
  }
}