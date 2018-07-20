import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:CleanerApp/chat.dart';
import 'package:CleanerApp/day.dart';
import 'package:small_calendar/small_calendar.dart';

class BioScreen extends StatefulWidget {
  String person;
  String avatar;

  BioScreen({String person, String avatar}) {
    this.person = person;
    this.avatar = avatar;
  }

  @override
  State<StatefulWidget> createState() => BioState(person, avatar);
}

class BioState extends State<BioScreen> {
  String title;
  String avatar;
  SmallCalendarPagerController _smallCalendarPagerController;
  String _displayedMonthText = "";
  DateFormat dateFormat = DateFormat.MMMM('en_GB');

  BioState(String person, String avatar) {
    this.title = '$person\'s Bio';
    this.avatar = avatar;
  }

  @override
  void initState() {
    super.initState();

    DateTime initialMonth = new DateTime.now();
    _displayedMonthText =
        "${dateFormat.format(initialMonth)} ${initialMonth.year}";
    DateTime minimumMonth =
        new DateTime(initialMonth.year - 1, initialMonth.month);
    DateTime maximumMonth =
        new DateTime(initialMonth.year + 1, initialMonth.month);

    _smallCalendarPagerController = new SmallCalendarPagerController(
      initialMonth: initialMonth,
      minimumMonth: minimumMonth,
      maximumMonth: maximumMonth,
    );
  }

  void _updateDisplayedMonthText() {
    setState(() {
      DateTime displayedMonth = _smallCalendarPagerController.displayedMonth;

      _displayedMonthText =
          "${dateFormat.format(displayedMonth)} ${displayedMonth.year}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(radius: 60.0, backgroundImage: AssetImage(avatar)),
              Text(
                getBio(),
                textAlign: TextAlign.center,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new Container(
                  color: Colors.white,
                  margin: new EdgeInsets.only(top: 50.0),
                  width: 300.0,
                  height: 300.0,
                  child: new SmallCalendarData(
                    child: new SmallCalendarStyle(
                      child: new SmallCalendarPager(
                        controller: _smallCalendarPagerController,
                        onMonthChanged: (DateTime month) =>
                            _updateDisplayedMonthText(),
                        pageBuilder: (BuildContext context, DateTime month) {
                          return new SmallCalendar(
                              month: month,
                              onDayTap: (date) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DayWidget(day: date)),
                                );
                              });
                        },
                      ),
                    ),
                  )),
              Text(_displayedMonthText, style: new TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.message),
            backgroundColor: new Color(0xFFE57373),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                )));
  }

  String getBio() =>
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.';
}
