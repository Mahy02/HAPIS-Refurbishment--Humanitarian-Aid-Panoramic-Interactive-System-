import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///This is a [Provider] class of [DateSelectionModel] that extends [ChangeNotifier]
///It includes all data related to the date and time in the section 3 of the form page
///It has the following:
///  *  [_isChecked1]  of type [bool] to check if the first check box of single event was selected or not
///  *  [_isChecked2]  of type [bool] to check if the second check box  of single event was selected or not
///  *  [_isChecked3]  of type [bool] to check if the  check box  of the recurring event was selected or not
///  *  [_dateControllerStart] of type  [TextEditingController] to get the data of the Event start Date entered by the user
///  *  [_dateControllerEnd] of type  [TextEditingController] to get the data of the Event End Date entered by the user
///  *  [_timeControllerStart] of type  [TextEditingController] to get the time of the Event start Date entered by the user
///  *  [_timeControllerEnd] of type  [TextEditingController] to get the time of the Event End Date entered by the user
/// we have a setter for   [_isChecked1] and  [_isChecked2] and [_isChecked3] only as those are the one we need to set inside the UI in setState
/// However the rest are managed by the controller
/// we have a getter for them all
/// we also added functions to show the calendar or clock for the user and get the data back such as"
///  * [showDatePickerStart]  to show the calendar and let user choose Event Start Date then it [notifyListeners]
///  * [showDatePickerEnd]  to show the calendar and let user choose Event End Date then it [notifyListeners]
/// Both of teh above use  [showDatePicker] built in functionallity
///  * [showTimePickerStart]  to show the Clock and let user choose Event Start time then it [notifyListeners]
///  * [showTimePickerStart]  to show the Clock and let user choose Event End time then it [notifyListeners]
/// both of the above use [showTimePicker] built in functionallity

class DateSelectionModel extends ChangeNotifier {
 

  TextEditingController _dateControllerStart =
      TextEditingController(text: '2023-05-12');
  TextEditingController _timeControllerStart =
      TextEditingController(text: '12:00 AM');
  // TextEditingController _dateControllerEnd =
  //     TextEditingController(text: '2023-05-14');
  // TextEditingController _timeControllerEnd =
  //     TextEditingController(text: '7:00 PM');

  

  set dateStart(String value) {
    _dateControllerStart.text = value;
    notifyListeners();
  }

  set timeStart(String value) {
    _timeControllerStart.text = value;
    notifyListeners();
  }

  // set dateEnd(String value) {
  //   _dateControllerEnd.text = value;
  //   notifyListeners();
  // }

  // set timeEnd(String value) {
  //   _timeControllerEnd.text = value;
  //   notifyListeners();
  // }

  set timeStartController(TextEditingController value) {
    _timeControllerStart = value;
    notifyListeners();
  }

  // set timeEndController(TextEditingController value) {
  //   _timeControllerEnd = value;
  //   notifyListeners();
 // }

  set dateStartController(TextEditingController value) {
    _dateControllerStart = value;
    notifyListeners();
  }

  // set dateEndController(TextEditingController value) {
  //   _dateControllerEnd = value;
  //   notifyListeners();
  // }

  // bool get isChecked1 => _isChecked1;
  // bool get isChecked2 => _isChecked2;
  // bool get isChecked3 => _isChecked3;
  TextEditingController get dateControllerStart => _dateControllerStart;
  TextEditingController get timeControllerStart => _timeControllerStart;
  // TextEditingController get dateControllerEnd => _dateControllerEnd;
  // TextEditingController get timeControllerEnd => _timeControllerEnd;

  DateTime _dateTime = DateTime.now();

  void showDatePickerStart(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    ).then((value) {
      if (value != null) {
        _dateTime = value;
        _dateControllerStart.text = DateFormat('yyyy-MM-dd').format(value);
        notifyListeners();
      }
    });
  }

  // void showDatePickerEnd(BuildContext context) {
  //   showDatePicker(
  //     context: context,
  //     initialDate: _dateTime,
  //     firstDate: DateTime(DateTime.now().year - 5),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //   ).then((value) {
  //     if (value != null) {
  //       _dateTime = value;
  //       _dateControllerEnd.text = DateFormat('yyyy-MM-dd').format(value);
  //       notifyListeners();
  //     }
  //   });
  // }

  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 30);
  void showTimePickerStart(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) {
        if (value != null) {
          _timeOfDay = value;
          _timeControllerStart.text = _timeOfDay.format(context);
          notifyListeners();
        }
      },
    );
  }

  // void showTimePickerEnd(BuildContext context) {
  //   showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then(
  //     (value) {
  //       if (value != null) {
  //         _timeOfDay = value;
  //         _timeControllerEnd.text = _timeOfDay.format(context);
  //         notifyListeners();
  //       }
  //     },
  //   );
  // }
}
