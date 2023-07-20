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
      required this.startDay,
     
     }) 
      : super(key: key);

  //start and end days should be input to the widget as well as checkboxvisibility
  final String startDay;


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
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    labelText: widget.startDay,
                    // hintText: '05/02/2023',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                    suffixIcon: const Text(
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
                  labelText: 'Start Time ',
                  // hintText: '7:00 PM',
                  labelStyle: TextStyle(
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                  suffixIcon: const Text(
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
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: SizedBox(
          //     // width: MediaQuery.of(context).size.width * 0.45,
          //     child: TextFormField(
          //       key: const ValueKey("DatePickerEnd"),
          //       onTap: () {
          //         model.showDatePickerEnd(context);
          //       },
          //       controller: model.dateControllerEnd,
          //       decoration: InputDecoration(
          //         prefixIcon: const Icon(Icons.calendar_month_outlined),
          //         // hintText: '05/02/2023',
          //         labelText: widget.endDay,
          //         labelStyle: const TextStyle(
          //           fontSize: 18,
          //         ),
          //         border: const OutlineInputBorder(),
          //         contentPadding:
          //             const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
          //         suffixIcon: const Text(
          //           '*',
          //           style: TextStyle(color: Colors.red, fontSize: 24),
          //         ),
          //       ),
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'This field is required';
          //         }
          //         return null;
          //       },
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: SizedBox(
          //     //width: MediaQuery.of(context).size.width * 0.45,
          //     child: TextFormField(
          //       key: const ValueKey("TimePickerEnd"),
          //       onTap: () {
          //         model.showTimePickerEnd(context);
          //       },
          //       controller: model.timeControllerEnd,
          //       decoration: const InputDecoration(
          //         labelText: 'End Time  ',
          //         // hintText: ' 10:00 PM',
          //         labelStyle: TextStyle(
          //           fontSize: 18,
          //         ),
          //         border: OutlineInputBorder(),
          //         contentPadding:
          //             EdgeInsets.symmetric(vertical: 32, horizontal: 10),
          //         suffixIcon: Text(
          //           '*',
          //           style: TextStyle(color: Colors.red, fontSize: 24),
          //         ),
          //       ),
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'This field is required';
          //         }
          //         return null;
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // widget.isCheckBoxVisibile
          //     ? ListTile(
          //         // ignore: prefer_const_constructors
          //         title: const Text(
          //             'Display start time. \n  The start time of your event will be displayed to attendees.',
          //             style: TextStyle(fontSize: 16, fontFamily: "Poppins")),
          //         leading: Checkbox(
          //           value: model.isChecked1,
          //           onChanged: (value) {
          //             setState(() {
          //               model.isChecked1 = value!;
          //             });
          //           },
          //         ),
          //       )
          //     : const SizedBox(
          //         height: 0,
          //       ),
          // widget.isCheckBoxVisibile
          //     ? const SizedBox(
          //         height: 20,
          //       )
          //     : const SizedBox(
          //         height: 0,
          //       ),
          // widget.isCheckBoxVisibile
          //     ? ListTile(
          //         // ignore: prefer_const_constructors
          //         title: const Text(
          //             'Display end time. \n The end time of your event will be displayed to attendees.',
          //             style: TextStyle(fontSize: 16, fontFamily: "Poppins")),
          //         leading: Checkbox(
          //           value: model.isChecked2,
          //           onChanged: (value) {
          //             setState(() {
          //               model.isChecked2 = value!;
          //             });
          //           },
          //         ),
          //       )
          //     : const SizedBox(
          //         height: 0,
          //       ),
        ],

        //missing time zone + event language ====> idk if need api or wait for backend to do them? or if we will need them?
      ),
    );
  }
}
