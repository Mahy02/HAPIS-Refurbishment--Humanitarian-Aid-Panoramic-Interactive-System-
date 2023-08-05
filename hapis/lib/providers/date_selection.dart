import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:intl/intl.dart';

///This is a [Provider] class of [DateSelectionModel] that extends [ChangeNotifier]
///It includes all data related to the date and time in the section 3 of the form page
///It has the following:
///  *  [_dateControllerStart] of type  [TextEditingController] to get the data of the Event start Date entered by the user
///  *  [_timeControllerStart] of type  [TextEditingController] to get the time of the Event start Date entered by the user

/// we have a getter for them all
/// we also added functions to show the calendar or clock for the user and get the data back such as"
///  * [showDatePickerStart]  to show the calendar and let user choose Event Start Date then it [notifyListeners]
/// Both of teh above use  [showDatePicker] built in functionallity
///  * [showTimePickerStart]  to show the Clock and let user choose Event Start time then it [notifyListeners]
///  * [showTimePickerStart]  to show the Clock and let user choose Event End time then it [notifyListeners]
/// both of the above use [showTimePicker] built in functionallity

class DateSelectionModel extends ChangeNotifier {
  TextEditingController _dateControllerStart =
      TextEditingController(text: '2023-05-12');
  TextEditingController _timeControllerStart =
      TextEditingController(text: '12:00 AM');

  set dateStart(String value) {
    _dateControllerStart.text = value;
    notifyListeners();
  }

  set timeStart(String value) {
    _timeControllerStart.text = value;
    notifyListeners();
  }

  set timeStartController(TextEditingController value) {
    _timeControllerStart = value;
    notifyListeners();
  }

  set dateStartController(TextEditingController value) {
    _dateControllerStart = value;
    notifyListeners();
  }

  TextEditingController get dateControllerStart => _dateControllerStart;
  TextEditingController get timeControllerStart => _timeControllerStart;

  DateTime _dateTime = DateTime.now();

  void showDatePickerStart(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 10),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  primary:
                      HapisColors.lgColor1), // Change the button text color
              buttonTheme: ButtonThemeData(
                  textTheme:
                      ButtonTextTheme.primary), // Change the button color
            ),
            child: child!,
          );
        }).then((value) {
      if (value != null) {
        _dateTime = value;
        _dateControllerStart.text = DateFormat('yyyy-MM-dd').format(value);
        notifyListeners();
      }
    });
  }

  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 30);
  void showTimePickerStart(BuildContext context) {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  primary:
                      HapisColors.lgColor1), // Change the button text color
              buttonTheme: ButtonThemeData(
                  textTheme:
                      ButtonTextTheme.primary), // Change the button color
            ),
            child: child!,
          );
        }).then(
      (value) {
        if (value != null) {
          _timeOfDay = value;
          _timeControllerStart.text = _timeOfDay.format(context);
          notifyListeners();
        }
      },
    );
  }
}
