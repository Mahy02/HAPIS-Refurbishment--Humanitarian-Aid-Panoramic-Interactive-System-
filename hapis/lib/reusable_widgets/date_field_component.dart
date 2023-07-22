import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/date_selection.dart';

///This is the UI that appears when user presses on 'Single Date' button
///It is a custom widget which is  [DateSelectionWidget]
///It returns [Consumer] of type [DateSelectionModel] to update UI accoridng to user input and save the data
///It has consists of 2 [Row] widgets each having 2  [TextFormField] for the date and time
/// on Tap on the textfields we show [showDatePickerStart] , [showTimePickerStart], [showTimePickerEnd] , [showDatePickerEnd] where they are accessed from the [DateSelectionModel]

class DateSelectionWidget extends StatefulWidget {
  const DateSelectionWidget(
      {Key? key,
    
     
     }) 
      : super(key: key);




  @override
  _DateSelectionWidgetState createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  //final DateSelectionModel _model = DateSelectionModel();
  //to access time of day we use=> _timeOfDay.format(context).toString()

  @override
  Widget build(BuildContext context) {
    return Consumer<DateSelectionModel>(
      builder: (BuildContext context, model, Widget? child) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        //For a single event:
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              //width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                key: const ValueKey("DatePickerStart"),
                onTap: () {
                  model.showDatePickerStart(context);
                },
                //_showDatePickerStart,
                controller: model.dateControllerStart,
                decoration: const InputDecoration(
                    prefixIcon:  Icon(Icons.calendar_month_outlined),
                    labelText: 'Day',
                    // hintText: '05/02/2023',
                    labelStyle:  TextStyle(
                      fontSize: 18,
                    ),
                    border:  OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                    suffixIcon:  Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 24),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              //width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                key: const ValueKey("TimePickerStart"),
                onTap: () {
                  model.showTimePickerStart(context);
                },
                controller: model.timeControllerStart,
                decoration: const InputDecoration(
                  labelText: 'Time ',
                  // hintText: '7:00 PM',
                  labelStyle: TextStyle(
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                  suffixIcon:  Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
         
        ],

        //missing time zone + event language ====> idk if need api or wait for backend to do them? or if we will need them?
      ),
    );
  }
}
