import 'package:flutter/material.dart';

class Tempahan {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  //constructor
  Tempahan(this.eventName, this.from, this.to, this.background, this.isAllDay);
}