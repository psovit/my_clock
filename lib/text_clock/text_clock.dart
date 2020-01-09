import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_clock/analog/analog_clock.dart';
import 'package:my_clock/model.dart';

class TextClock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TextClockState();
}

class _TextClockState extends State<TextClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  TextStyle _baseTextStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.grey,
    letterSpacing: 4.0,
  );

  TextStyle get _baseBoldStyle =>
      _baseTextStyle.copyWith(fontWeight: FontWeight.bold);

  TextStyle get _whiteText => _baseBoldStyle.copyWith(
        color: Colors.white,
      );
  TextStyle get _yellowText => _baseBoldStyle.copyWith(
        color: Colors.yellow,
      );

  TextStyle get _greenText => _baseBoldStyle.copyWith(
        color: Color(0xff00FF41),
      );

  TextStyle get _redText => _baseBoldStyle.copyWith(color: Colors.red);

  TextStyle get _blueText => _baseBoldStyle.copyWith(color: Colors.blueAccent);

  TextStyle get _purpleText =>
      _baseBoldStyle.copyWith(color: Colors.purpleAccent);

  TextStyle get _greyText => _baseTextStyle;

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  String get _hourText => _numberToHourText();
  String get _dayText => _numberToDayText();

  bool get _isThirtyMinsArnd => _dateTime.minute > 27 && _dateTime.minute < 33;
  bool get _isQuarter =>
      (_dateTime.minute > 12 && _dateTime.minute < 18) ||
      (_dateTime.minute > 42 && _dateTime.minute < 48);
  bool get _isPast => (_dateTime.minute > 2 && _dateTime.minute < 33);
  bool get _isExact => (_dateTime.minute < 3 || _dateTime.minute > 57);
  bool get _isTen =>
      (_dateTime.minute > 7 && _dateTime.minute < 13) ||
      (_dateTime.minute > 47 && _dateTime.minute < 53);
  bool get _isTwenty =>
      (_dateTime.minute > 17 && _dateTime.minute < 28) ||
      (_dateTime.minute > 32 && _dateTime.minute < 43);
  bool get _isFive =>
      (_dateTime.minute > 2 && _dateTime.minute < 8) ||
      (_dateTime.minute > 22 && _dateTime.minute < 28) ||
      (_dateTime.minute > 32 && _dateTime.minute < 38) ||
      (_dateTime.minute > 52 && _dateTime.minute <= 59);

  _numberToHourText() {
    var hr = _dateTime.hour;
    if (hr > 12) {
      hr = hr - 12;
    }
    if (_dateTime.minute > 32) {
      hr++;
    }
    switch (hr) {
      case 1:
        return "ONE";
      case 2:
        return "TWO";
      case 3:
        return "THREE";
      case 4:
        return "FOUR";
      case 5:
        return "FIVE";
      case 6:
        return "SIX";
      case 7:
        return "SEVEN";
      case 8:
        return "EIGHT";
      case 9:
        return "NINE";
      case 10:
        return "TEN";
      case 11:
        return "ELEVEN";
      case 12:
        return "TWELVE";
      default:
        return "ZERO";
    }
  }

  _numberToDayText() {
    switch (_dateTime.weekday) {
      case 1:
        return "MON";
      case 2:
        return "TUE";
      case 3:
        return "WED";
      case 4:
        return "THU";
      case 5:
        return "FRI";
      case 6:
        return "SAT";
      case 7:
        return "SUN";
    }
  }

  ClockModel _clockModel;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockModel = ClockModel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _clockModel?.dispose();
    super.dispose();
  }

  RichText _buildLocationText() {
    var location = _clockModel.location.toString().toUpperCase();
    if (location.length == 11) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(text: location, style: _whiteText),
        ]),
      );
    }
    if (location.length < 11) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(text: location, style: _whiteText),
          TextSpan(
              text: "".padRight(11 - location.length, '|'), style: _greyText),
        ]),
      );
    }
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: location.substring(0,9) + "..", style: _whiteText),
      ]),
    );
  }

  Widget _buildTextOnTheLeft() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildLocationText(),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "AL",
                style: _greyText,
              ),
              TextSpan(text: "IT", style: _yellowText),
              TextSpan(text: "ASG", style: _greyText),
              TextSpan(text: "IS", style: _yellowText),
              TextSpan(text: "RFI", style: _greyText)
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "|",
                style: _greyText,
              ),
              TextSpan(
                text: _dateTime.month.toString(),
                style: _whiteText,
              ),
              TextSpan(
                text: "/",
                style: _greyText,
              ),
              TextSpan(
                text: _dateTime.day.toString().padLeft(2, '0'),
                style: _blueText,
              ),
              TextSpan(
                text: "/",
                style: _greyText,
              ),
              TextSpan(
                text: _dateTime.year.toString(),
                style: _whiteText,
              ),
              TextSpan(
                text: "|",
                style: _greyText,
              ),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "AM",
                  style: _dateTime.hour < 12 ? _redText : _greyText),
              TextSpan(text: "IT", style: _greyText),
              TextSpan(
                  text: "PM",
                  style: _dateTime.hour > 12 ? _purpleText : _greyText),
              TextSpan(
                  text: "SUN",
                  style: _dayText == "SUN" ? _blueText : _greyText),
              TextSpan(text: "XD", style: _greyText),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "MON",
                  style: _dayText == "MON" ? _blueText : _greyText),
              TextSpan(text: "P", style: _greyText),
              TextSpan(
                  text: "WED",
                  style: _dayText == "WED" ? _blueText : _greyText),
              TextSpan(
                  text: "TGIF",
                  style: _dayText == "FRI" ? _blueText : _greyText),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "TUE",
                  style: _dayText == "TUE" ? _blueText : _greyText),
              TextSpan(
                  text: "SAT",
                  style: _dayText == "SAT" ? _blueText : _greyText),
              TextSpan(text: "OV", style: _greyText),
              TextSpan(
                  text: "THU",
                  style: _dayText == "THU" ? _blueText : _greyText),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "PSO", style: _greyText),
              TextSpan(text: "ABOUT", style: _yellowText),
              TextSpan(text: "VIT", style: _greyText),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "NOW", style: _whiteText),
              TextSpan(text: "RQ", style: _greyText),
              TextSpan(
                  text: _clockModel.temperature.toString() +
                      _clockModel.unitString,
                  style: _redText),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "CH", style: _greyText),
              TextSpan(
                  text: _clockModel.weatherString
                      .toString()
                      .substring(0, 5)
                      .toUpperCase(),
                  style: _purpleText),
              TextSpan(text: "ANK", style: _greyText),
            ]),
          )
        ]);
  }

  _buildTextOnTheRight() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RichText(
          text: TextSpan(children: [
            TextSpan(text: "CH", style: _greyText),
            TextSpan(
              text: "QUARTER",
              style: _isQuarter ? _whiteText : _greyText,
            ),
            TextSpan(text: "BT", style: _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: "TWENTY", style: _isTwenty ? _whiteText : _greyText),
            TextSpan(
              text: "FIVE",
              style: _isFive ? _whiteText : _greyText,
            ),
            TextSpan(text: "X", style: _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "HALF",
                style: _isThirtyMinsArnd ? _whiteText : _greyText),
            TextSpan(text: "UU", style: _greyText),
            TextSpan(text: "TEN", style: _isTen ? _whiteText : _greyText),
            TextSpan(
                text: "TO",
                style: (!_isPast && !_isExact) ? _purpleText : _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: "PAST", style: _isPast ? _redText : _greyText),
            TextSpan(text: "ERU", style: _greyText),
            TextSpan(
                text: "NINE",
                style: _hourText == "NINE" ? _greenText : _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "ONE",
                style: _hourText == "ONE" ? _greenText : _greyText),
            TextSpan(
                text: "SIX",
                style: _hourText == "SIX" ? _greenText : _greyText),
            TextSpan(
                text: "THREE",
                style: _hourText == "THREE" ? _greenText : _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "FOUR",
                style: _hourText == "FOUR" ? _greenText : _greyText),
            TextSpan(
                text: "FIVE",
                style: _hourText == "FIVE" ? _greenText : _greyText),
            TextSpan(
                text: "TWO",
                style: _hourText == "TWO" ? _greenText : _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "EIGHT",
                style: _hourText == "EIGHT" ? _greenText : _greyText),
            TextSpan(
                text: "ELVEN",
                style: _hourText == "ELEVEN" ? _greenText : _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "SEVEN",
                style: _hourText == "SEVEN" ? _greenText : _greyText),
            TextSpan(
                text: "TWELVE",
                style: _hourText == "TWELVE" ? _greenText : _greyText),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "TEN",
                style: _hourText == "TEN" ? _greenText : _greyText),
            TextSpan(text: "O'", style: _blueText),
            TextSpan(text: "SE", style: _greyText),
            TextSpan(text: "CLOCK", style: _yellowText),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context);
    return Container(
      height: mediaQ.size.height,
      width: mediaQ.size.width,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTextOnTheLeft(),
          Container(child:AnalogClock(_clockModel), margin: EdgeInsets.all(8.0),),
          _buildTextOnTheRight()
        ],
      ),
    );
  }
}
