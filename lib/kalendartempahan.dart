import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:tempahanbilikadmin/tempahan.dart';
import 'package:tempahanbilikadmin/tempahandatasource.dart';

class KalendarTempahan extends StatefulWidget {
  const KalendarTempahan({super.key});

  @override
  State<KalendarTempahan> createState() => _KalendarTempahanState();
}

class _KalendarTempahanState extends State<KalendarTempahan> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TempahanDataSource? events;

  Future<void> getTempahan() async {
    var snapshots = await firestore
        .collection("tempahan")
        .where('status', isEqualTo: 'lulus')
        .get();

    List<Tempahan> list = snapshots.docs
        .map((e) => Tempahan(
            e.data()['name'],
            DateFormat('yyyy-MM-dd HH:mm').parse(e.data()['mula']),
            DateFormat('yyyy-MM-dd HH:mm').parse(e.data()['tamat']),
            Color(int.parse(e.data()['warna'])),
            false))
        .toList();
    setState(() {
      events = TempahanDataSource(list);
    });
  }

  @override
  void initState() {
    super.initState();
    getTempahan();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendar Tempahan'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: () {
                getTempahan();
                setState(() {
                  debugPrint('Refresh');
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: SfCalendar(
        view: CalendarView.month,
        initialDisplayDate: DateTime(2022, 9, 13, 9, 0, 0),
        dataSource: events,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
        ),
      ),
    );
  }
}
