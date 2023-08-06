import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/providers/form_provider.dart';
import 'package:hapis/utils/database_popups.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/db_models/user_model.dart';
import '../providers/date_selection.dart';
import '../screens/form_page.dart';
import '../services/db_services/users_services.dart';
import '../utils/edit_form_popup.dart';
import '../utils/show_user_details_modal.dart';

class PersonalFormComponent extends StatefulWidget {
  final double fontSize;
  final UserModel form;
  final double editSize;
  final double deletesize;
  final VoidCallback onPressed;
  const PersonalFormComponent(
      {super.key,
      required this.fontSize,
      required this.form,
      required this.editSize,
      required this.deletesize,
      required this.onPressed});

  @override
  State<PersonalFormComponent> createState() => _PersonalFormComponentState();
}

class _PersonalFormComponentState extends State<PersonalFormComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.form.type == 'giver') {
          showUserDetails(
              context,
              '${widget.form.firstName} ${widget.form.lastName} ',
              widget.form.email,
              widget.form.phoneNum,
              widget.form.city,
              widget.form.category,
              widget.form.item,
              widget.form.multiDates,
              widget.form.addressLocation,
              'giver',
              widget.fontSize);
        } else {
          showUserDetails(
              context,
              '${widget.form.firstName} ${widget.form.lastName} ',
              widget.form.email,
              widget.form.phoneNum,
              widget.form.city,
              widget.form.category,
              widget.form.item,
              widget.form.multiDates,
              widget.form.addressLocation,
              'seeker',
              widget.fontSize);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: HapisColors.lgColor1),
          borderRadius: BorderRadius.circular(20),
        ),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () async {
                  if (await UserServices()
                      .isFormInProgress(widget.form.formID!)) {
                    //no edits
                    showEditErrorPopUp(context, 'editing');
                  } else {
                    FormProvider formProvider =
                        Provider.of<FormProvider>(context, listen: false);
                    DateSelectionModel datesProvider =
                        Provider.of<DateSelectionModel>(context, listen: false);

                    String dates = widget.form.multiDates!;
                    List<String> dateList = dates
                        .split(',')
                        .map((dateString) => dateString.split(' ')[0])
                        .toList();

                    List<String> timeList = dates.split(',').map((dateString) {
                      String timeString = dateString.split(' ')[1];
                      DateTime dateTime =
                          DateFormat('HH:mm:ss').parse(timeString);
                      String formattedTime =
                          DateFormat('h:mm a').format(dateTime);
                      return formattedTime;
                    }).toList();

                    List<DateSelectionModel> _selectedDates = [];
                    for (int i = 0; i < dateList.length; i++) {
                      datesProvider.dateStart = dateList[i];
                      datesProvider.timeStart = timeList[i];
                      _selectedDates.add(datesProvider);
                    }
                    print(_selectedDates);

                    if (widget.form.type == 'seeker') {
                      formProvider.categoryS = widget.form.category!;
                      formProvider.formItemControllerS.text = widget.form.item!;
                      formProvider.typeD = widget.form.type!;
                      formProvider.typeS = widget.form.type!;
                      formProvider.forWhoS = widget.form.forWho!;
                    } else if (widget.form.type == 'giver') {
                      formProvider.categoryD = widget.form.category!;
                      formProvider.formItemControllerD.text = widget.form.item!;
                      formProvider.typeD = widget.form.type!;
                      formProvider.typeS = widget.form.type!;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CreateForm(
                                type: formProvider.typeD,
                                selectedDates: _selectedDates,
                                update: true,
                                formID: widget.form.formID!,
                              )),
                    );
                  }
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: HapisColors.lgColor3)),
                    child: Icon(
                      Icons.mode_edit_outline,
                      color: HapisColors.lgColor3,
                      size: widget.editSize,
                    )),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.form.type! == 'seeker')
                    Text(
                      'Seeking',
                      style: TextStyle(
                          fontSize: widget.fontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  if (widget.form.type! == 'seeker')
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  if (widget.form.type! == 'giver')
                    Text(
                      'Donating',
                      style: TextStyle(
                          fontSize: widget.fontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  if (widget.form.type! == 'giver')
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.form.item!,
                      style: TextStyle(
                          fontSize: widget.fontSize, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (await UserServices()
                    .isFormInProgress(widget.form.formID!)) {
                  //no edits
                  showEditErrorPopUp(context, 'deleting');
                } else {
                  int result =
                      await UserServices().deleteForm(widget.form.formID!);
                  if (result == 1) {
                    showDatabasePopup(context, 'Form deleted successfully!',
                        isError: false);
                  } else if (result == 0) {
                    showDatabasePopup(context,
                        'Error deleting form \n\nPlease try again later.');
                  }
                  widget.onPressed();
                }
              },
              child: Icon(
                Icons.delete,
                color: HapisColors.lgColor2,
                size: widget.deletesize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
