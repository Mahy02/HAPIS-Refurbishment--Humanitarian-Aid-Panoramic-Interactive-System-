import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';

import 'package:hapis/providers/form_provider.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/services/db_services/matchings_db_services.dart';
import 'package:hapis/services/db_services/users_services.dart';
import 'package:hapis/utils/database_popups.dart';
import 'package:hapis/utils/drawer.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../providers/date_selection.dart';
import '../reusable_widgets/back_button.dart';
import '../reusable_widgets/date_day_component.dart';
import '../reusable_widgets/date_time_component.dart';
import '../reusable_widgets/drop_down_list_component.dart';
import '../reusable_widgets/text_form_field.dart';
import '../utils/empty_date_popup.dart';

/// This is a widget responsible for creating or editing forms
class CreateForm extends StatefulWidget {
  final List<DateSelectionModel> selectedDates;
  final String? type;
  final bool update;
  final int formID;
  const CreateForm({
    Key? key,
    required this.selectedDates,
    required this.type,
    required this.update,
    required this.formID,
  }) : super(key: key);

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  List<DateSelectionModel> _selectedDatesSeeker = [];
  List<DateSelectionModel> _selectedDatesGiver = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      if (widget.type == 'seeker') {
        for (int i = 0; i < widget.selectedDates.length; i++) {
          _selectedDatesSeeker.add(widget.selectedDates[i]);
        }
      } else if (widget.type == 'giver') {
        for (int i = 0; i < widget.selectedDates.length; i++) {
          _selectedDatesGiver.add(widget.selectedDates[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String id;

    id = LoginSessionSharedPreferences.getUserID() ?? '0';

    return Scaffold(
      appBar: const HAPISAppBar(isLg: false, appBarText: ''),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, false, 18, 16),
          tabletBody: buildDrawer(context, false, 24, 20)),
      body: Consumer2<FormProvider, FormProvider>(
        builder:
            (BuildContext context, donorModel, seekerModel, Widget? child) {
          int typeIndexDonor = typeList.indexOf(donorModel.typeD);
          int categoryIndexDonor = categoryList.indexOf(donorModel.categoryD);

          int typeIndexSeeker = typeList.indexOf(seekerModel.typeS);
          int categoryIndexSeeker = categoryList.indexOf(seekerModel.categoryS);
          int forWhoIndexSeeker = forWhoList.indexOf(seekerModel.forWhoS);

          return ResponsiveLayout(
              mobileBody: buildMobileLayout(
                  donorModel,
                  seekerModel,
                  typeIndexSeeker,
                  typeIndexDonor,
                  categoryIndexDonor,
                  categoryIndexSeeker,
                  forWhoIndexSeeker,
                  id),
              tabletBody: buildTabletLayout(
                  donorModel,
                  seekerModel,
                  typeIndexSeeker,
                  typeIndexDonor,
                  categoryIndexDonor,
                  categoryIndexSeeker,
                  forWhoIndexSeeker,
                  id));
        },
      ),
    );
  }

  Widget buildMobileLayout(
      FormProvider donorModel,
      FormProvider seekerModel,
      int typeIndexSeeker,
      int typeIndexDonor,
      int categoryIndexDonor,
      int categoryIndexSeeker,
      int forWhoIndexSeeker,
      String id) {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              BackButtonWidget(
                isTablet: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fill the Donation Form',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        const FormSubHeading(
                          subtext: 'Donate ? Seek? or Both?',
                          fontSize: 18,
                        ),
                        Column(
                          children: [
                            DropDownListWidget(
                              key: const ValueKey("type"),
                              fontSize: 16,
                              items: typeList,
                              selectedValue: typeIndexDonor != -1
                                  ? typeList[typeIndexDonor]
                                  : typeList[0],
                              hinttext: 'Type',
                              onChanged: (value) {
                                setState(() {
                                  donorModel.typeD = value;
                                  seekerModel.typeS = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Seeking for Who?',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              DropDownListWidget(
                                key: const ValueKey("forWho"),
                                fontSize: 16,
                                items: forWhoList,
                                selectedValue: forWhoIndexSeeker != -1
                                    ? forWhoList[forWhoIndexSeeker]
                                    : forWhoList[0],
                                hinttext: 'For Who',
                                onChanged: (value) {
                                  setState(() {
                                    seekerModel.forWhoS = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Choose the category you are seeking',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              DropDownListWidget(
                                key: const ValueKey("category"),
                                fontSize: 16,
                                items: categoryList,
                                selectedValue: categoryIndexSeeker != -1
                                    ? categoryList[categoryIndexSeeker]
                                    : categoryList[0],
                                hinttext: 'Category',
                                onChanged: (value) {
                                  setState(() {
                                    seekerModel.categoryS = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Choose the category you wish to donate',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              DropDownListWidget(
                                key: const ValueKey("category"),
                                fontSize: 16,
                                items: categoryList,
                                selectedValue: categoryIndexDonor != -1
                                    ? categoryList[categoryIndexDonor]
                                    : categoryList[0],
                                hinttext: 'Category',
                                onChanged: (value) {
                                  setState(() {
                                    donorModel.categoryD = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Specify the item you wish to donate',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              TextFormFieldWidget(
                                key: const ValueKey("itemgiver"),
                                textController: donorModel.formItemControllerD,
                                hint: 'Enter the item you prefer',
                                maxLength: 25,
                                isHidden: false,
                                isSuffixRequired: true,
                                label: 'Item ',
                                fontSize: 16,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Specify the item you need',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              TextFormFieldWidget(
                                key: const ValueKey("itemseek"),
                                textController: seekerModel.formItemControllerS,
                                hint: 'Enter the item you prefer',
                                maxLength: 20,
                                isHidden: false,
                                isSuffixRequired: true,
                                label: 'Item ',
                                fontSize: 16,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext:
                                'Specify all available dates for you to pick the item you need',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          CircleAvatar(
                            backgroundColor: HapisColors.lgColor3,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDatesSeeker
                                      .add(DateSelectionModel());
                                });
                              },
                            ),
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedDatesSeeker.length,
                            itemBuilder: (context, index) {
                              final dateModel = _selectedDatesSeeker[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 30),
                                      child: Column(
                                        children: [
                                          DateDayComponent(
                                            dateModel: dateModel,
                                            fontSize: 16,
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                          DateTimeComponent(
                                            dateModel: dateModel,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  CircleAvatar(
                                    backgroundColor: HapisColors.lgColor3,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedDatesSeeker.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        if (donorModel.typeD == 'both')
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext:
                                'Specify all available dates for you to donate the item',
                            fontSize: 18,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          CircleAvatar(
                            backgroundColor: HapisColors.lgColor3,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDatesGiver.add(DateSelectionModel());
                                });
                              },
                            ),
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedDatesGiver.length,
                            itemBuilder: (context, index) {
                              final dateModel = _selectedDatesGiver[index];

                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 30),
                                      child: Column(
                                        children: [
                                          DateDayComponent(
                                            dateModel: dateModel,
                                            fontSize: 16,
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                          DateTimeComponent(
                                            dateModel: dateModel,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  CircleAvatar(
                                    backgroundColor: HapisColors.lgColor3,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedDatesGiver.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          int numberOfChanges = 0;
          int rows = 0;

          bool isFormValid = _formKey.currentState?.validate() ?? false;
          if (isFormValid) {
            String datesG = '';
            String datesS = '';

            for (int i = 0; i < _selectedDatesGiver.length; i++) {
              String date = _selectedDatesGiver[i].dateControllerStart.text;
              String time = _selectedDatesGiver[i].timeControllerStart.text;
              DateFormat inputFormat = DateFormat("h:mm a");
              DateTime parsedTime = inputFormat.parse(time);

              DateFormat outputFormat =
                  DateFormat("HH:mm"); // Format for 24-hour time
              String timeString =
                  outputFormat.format(parsedTime); // Convert to 24-hour format
              String dateTimeString = '$date ${'$timeString:00'}';
              datesG += dateTimeString;
              if (i != _selectedDatesGiver.length - 1) {
                datesG += ',';
              }
            }
            for (int i = 0; i < _selectedDatesSeeker.length; i++) {
              String date = _selectedDatesSeeker[i].dateControllerStart.text;
              String time = _selectedDatesSeeker[i].timeControllerStart.text;
              DateFormat inputFormat = DateFormat("h:mm a");
              DateTime parsedTime = inputFormat.parse(time);

              DateFormat outputFormat =
                  DateFormat("HH:mm"); // Format for 24-hour time
              String timeString =
                  outputFormat.format(parsedTime); // Convert to 24-hour format
              String dateTimeString = '$date ${'$timeString:00'}';
              datesS += dateTimeString;
              if (i != _selectedDatesSeeker.length - 1) {
                datesS += ',';
              }
            }
//////////////////////////////////////////////////////////////////////////////////////////
            if (donorModel.typeD == 'seeker') {
              if (datesS.isEmpty) {
                showDatePopUp(context);
              } else {
                setState(() {
                  isLoading = true;
                });
                int rowID = 0;

                if (widget.update == true) {
                  numberOfChanges = await UserServices().updateForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed',
                      widget.formID);

                  if (numberOfChanges == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    //check match
                    //but first get city of userID
                    String city = await UserServices().getCity(id);
                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        MatchingsServices()
                            .createMatch(widget.formID, formIds[i]!);
                      }
                    }
                  }
                } else {
                  rowID = await UserServices().createNewForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed');
                  rows = rowID;
                  if (rowID <= 0) {
                    //error creating form
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    //check match
                    //but first get city of userID
                    String city = await UserServices().getCity(id);
                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        MatchingsServices().createMatch(rowID, formIds[i]!);
                      }
                    }
                  }
                }
              }
              /////////////////////////////////////////////////////////////////////////
            } else if (donorModel.typeD == 'giver') {
              if (datesG.isEmpty) {
                showDatePopUp(context);
              } else {
                setState(() {
                  isLoading = true;
                });
                int rowID = 0;
                if (widget.update == true) {
                  numberOfChanges = await UserServices().updateForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed',
                      widget.formID);
                  if (numberOfChanges == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    String city = await UserServices().getCity(id);

                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        int matchID = await MatchingsServices()
                            .createMatch(formIds[i]!, widget.formID);
                      }
                    }
                  }
                } else {
                  rowID = await UserServices().createNewForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed');
                  rows = rowID;
                  if (rowID <= 0) {
                    setState(() {
                      isLoading = false;
                    });
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    String city = await UserServices().getCity(id);

                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        int matchID = await MatchingsServices()
                            .createMatch(formIds[i]!, rowID);
                      }
                    }
                  }
                }
              }
              //////////////////////////////////////////////////////////////////////////////////////
            } else {
              if (datesG.isEmpty || datesS.isEmpty) {
                showDatePopUp(context);
              } else {
                setState(() {
                  isLoading = true;
                });
                int rowIDS = 0;
                int numberOfChangesS = 0;

                if (widget.update == true) {
                  numberOfChangesS = await UserServices().updateForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed',
                      widget.formID);
                  if (numberOfChangesS == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsG = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIdsG.isNotEmpty) {
                      for (int i = 0; i < formIdsG.length; i++) {
                        MatchingsServices()
                            .createMatch(widget.formID, formIdsG[i]!);
                      }
                    }
                  }
                } else {
                  rowIDS = await UserServices().createNewForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed');
                  rows = rowIDS;
                  if (rowIDS <= 0) {
                    setState(() {
                      isLoading = false;
                    });
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsG = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIdsG.isNotEmpty) {
                      for (int i = 0; i < formIdsG.length; i++) {
                        MatchingsServices().createMatch(rowIDS, formIdsG[i]!);
                      }
                    }
                  }
                }

                int rowIDG = 0;
                int numberOfChangesG = 0;

                if (widget.update == true) {
                  numberOfChangesG = await UserServices().updateForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed',
                      widget.formID);

                  if (numberOfChangesG == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsS = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIdsS.isNotEmpty) {
                      for (int i = 0; i < formIdsS.length; i++) {
                        MatchingsServices()
                            .createMatch(formIdsS[i]!, widget.formID);
                      }
                    }
                  }
                } else {
                  rowIDG = await UserServices().createNewForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed');
                  rows = rowIDG;
                  if (rowIDG <= 0) {
                    setState(() {
                      isLoading = false;
                    });
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsS = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIdsS.isNotEmpty) {
                      for (int i = 0; i < formIdsS.length; i++) {
                        MatchingsServices().createMatch(formIdsS[i]!, rowIDG);
                      }
                    }
                  }
                }
                numberOfChanges = numberOfChangesS + numberOfChangesG;
              }
            }
            // ignore: use_build_context_synchronously

            if (numberOfChanges <= 0 && widget.update == true) {
            } else {
              if (widget.update == true) {
                setState(() {
                  isLoading = false;
                });
                showDatabasePopup(context, 'Form updated successfully!',
                    isError: false, onOKPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppHomePage()));
                });
              } else {
                if (rows > 0) {
                  setState(() {
                    isLoading = false;
                  });
                  showDatabasePopup(context, 'Form created successfully!',
                      isError: false, onOKPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppHomePage()));
                  });
                }
              }
            }
          }
          /////////////////////////////////////////////////////////////////////////
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 20.0, bottom: 20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              backgroundColor: HapisColors.lgColor4,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      if (isLoading)
        Positioned.fill(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ),
    ]);
  }

  Widget buildTabletLayout(
      FormProvider donorModel,
      FormProvider seekerModel,
      int typeIndexSeeker,
      int typeIndexDonor,
      int categoryIndexDonor,
      int categoryIndexSeeker,
      int forWhoIndexSeeker,
      String id) {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              BackButtonWidget(
                isTablet: true,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fill the Donation Form',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        const FormSubHeading(
                          subtext: 'Donate ? Seek? or Both?',
                          fontSize: 25,
                        ),
                        Column(
                          children: [
                            DropDownListWidget(
                              key: const ValueKey("type"),
                              fontSize: 22,
                              items: typeList,
                              selectedValue: typeIndexDonor != -1
                                  ? typeList[typeIndexDonor]
                                  : typeList[0],
                              hinttext: 'Type',
                              onChanged: (value) {
                                setState(() {
                                  donorModel.typeD = value;
                                  seekerModel.typeD = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Seeking for Who?',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              DropDownListWidget(
                                key: const ValueKey("forWho"),
                                fontSize: 22,
                                items: forWhoList,
                                selectedValue: forWhoIndexSeeker != -1
                                    ? forWhoList[forWhoIndexSeeker]
                                    : forWhoList[0],
                                hinttext: 'For Who',
                                onChanged: (value) {
                                  setState(() {
                                    seekerModel.forWhoS = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Choose the category you are seeking',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              DropDownListWidget(
                                key: const ValueKey("category"),
                                fontSize: 22,
                                items: categoryList,
                                selectedValue: categoryIndexSeeker != -1
                                    ? categoryList[categoryIndexSeeker]
                                    : categoryList[0],
                                hinttext: 'Category',
                                onChanged: (value) {
                                  setState(() {
                                    seekerModel.categoryS = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Choose the category you wish to donate',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              DropDownListWidget(
                                key: const ValueKey("category"),
                                fontSize: 22,
                                items: categoryList,
                                selectedValue: categoryIndexDonor != -1
                                    ? categoryList[categoryIndexDonor]
                                    : categoryList[0],
                                hinttext: 'Category',
                                onChanged: (value) {
                                  setState(() {
                                    donorModel.categoryD = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Specify the item you wish to donate',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              TextFormFieldWidget(
                                key: const ValueKey("item"),
                                textController: donorModel.formItemControllerD,
                                hint: 'Enter the item you prefer',
                                maxLength: 20,
                                isHidden: false,
                                isSuffixRequired: true,
                                label: 'Item ',
                                fontSize: 22,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext: 'Specify the item you need',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          Column(
                            children: [
                              TextFormFieldWidget(
                                key: const ValueKey("item"),
                                textController: seekerModel.formItemControllerS,
                                hint: 'Enter the item you prefer',
                                maxLength: 25,
                                isHidden: false,
                                isSuffixRequired: true,
                                label: 'Item ',
                                fontSize: 20,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext:
                                'Specify all available dates for you to pick the item you need',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          CircleAvatar(
                            backgroundColor: HapisColors.lgColor3,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDatesSeeker
                                      .add(DateSelectionModel());
                                });
                              },
                            ),
                          ),
                        if (donorModel.typeD == 'seeker' ||
                            donorModel.typeD == 'both')
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedDatesSeeker.length,
                            itemBuilder: (context, index) {
                              final dateModel = _selectedDatesSeeker[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 30),
                                      child: Column(
                                        children: [
                                          DateDayComponent(
                                            dateModel: dateModel,
                                            fontSize: 22,
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                          DateTimeComponent(
                                            dateModel: dateModel,
                                            fontSize: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  CircleAvatar(
                                    backgroundColor: HapisColors.lgColor3,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedDatesSeeker.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        if (donorModel.typeD == 'both')
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          const FormSubHeading(
                            subtext:
                                'Specify all available dates for you to donate the item',
                            fontSize: 25,
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          CircleAvatar(
                            backgroundColor: HapisColors.lgColor3,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDatesGiver.add(DateSelectionModel());
                                });
                              },
                            ),
                          ),
                        if (donorModel.typeD == 'giver' ||
                            donorModel.typeD == 'both')
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedDatesGiver.length,
                            itemBuilder: (context, index) {
                              final dateModel = _selectedDatesGiver[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 30),
                                      child: Column(
                                        children: [
                                          DateDayComponent(
                                            dateModel: dateModel,
                                            fontSize: 22,
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                          DateTimeComponent(
                                            dateModel: dateModel,
                                            fontSize: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  CircleAvatar(
                                    backgroundColor: HapisColors.lgColor3,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedDatesGiver.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          int numberOfChanges = 0;
          int rows = 0;

          bool isFormValid = _formKey.currentState?.validate() ?? false;
          if (isFormValid) {
            String datesG = '';
            String datesS = '';

            for (int i = 0; i < _selectedDatesGiver.length; i++) {
              String date = _selectedDatesGiver[i].dateControllerStart.text;
              String time = _selectedDatesGiver[i].timeControllerStart.text;
              DateFormat inputFormat = DateFormat("h:mm a");
              DateTime parsedTime = inputFormat.parse(time);

              DateFormat outputFormat =
                  DateFormat("HH:mm"); // Format for 24-hour time
              String timeString =
                  outputFormat.format(parsedTime); // Convert to 24-hour format
              String dateTimeString = '$date ${'$timeString:00'}';
              datesG += dateTimeString;
              if (i != _selectedDatesGiver.length - 1) {
                datesG += ',';
              }
            }
            for (int i = 0; i < _selectedDatesSeeker.length; i++) {
              String date = _selectedDatesSeeker[i].dateControllerStart.text;
              String time = _selectedDatesSeeker[i].timeControllerStart.text;
              DateFormat inputFormat = DateFormat("h:mm a");
              DateTime parsedTime = inputFormat.parse(time);

              DateFormat outputFormat =
                  DateFormat("HH:mm"); // Format for 24-hour time
              String timeString =
                  outputFormat.format(parsedTime); // Convert to 24-hour format
              String dateTimeString = '$date ${'$timeString:00'}';
              datesS += dateTimeString;
              if (i != _selectedDatesSeeker.length - 1) {
                datesS += ',';
              }
            }
//////////////////////////////////////////////////////////////////////////////////////////
            if (donorModel.typeD == 'seeker') {
              if (datesS.isEmpty) {
                showDatePopUp(context);
              } else {
                setState(() {
                  isLoading = true;
                });
                int rowID = 0;

                if (widget.update == true) {
                  numberOfChanges = await UserServices().updateForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed',
                      widget.formID);

                  if (numberOfChanges == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    //check match
                    //but first get city of userID
                    String city = await UserServices().getCity(id);
                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        MatchingsServices()
                            .createMatch(widget.formID, formIds[i]!);
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  rowID = await UserServices().createNewForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed');
                  rows = rowID;
                  if (rowID <= 0) {
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    //check match
                    //but first get city of userID
                    String city = await UserServices().getCity(id);
                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        MatchingsServices().createMatch(rowID, formIds[i]!);
                      }
                    }
                  }
                }
                setState(() {
                  isLoading = false;
                });
              }
              /////////////////////////////////////////////////////////////////////////
            } else if (donorModel.typeD == 'giver') {
              if (datesG.isEmpty) {
                showDatePopUp(context);
              } else {
                setState(() {
                  isLoading = true;
                });
                int rowID = 0;
                if (widget.update == true) {
                  numberOfChanges = await UserServices().updateForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed',
                      widget.formID);
                  if (numberOfChanges == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    String city = await UserServices().getCity(id);

                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        int matchID = await MatchingsServices()
                            .createMatch(formIds[i]!, widget.formID);
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  rowID = await UserServices().createNewForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed');
                  rows = rowID;
                  if (rowID <= 0) {
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    String city = await UserServices().getCity(id);

                    List<int?> formIds = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIds.isNotEmpty) {
                      for (int i = 0; i < formIds.length; i++) {
                        int matchID = await MatchingsServices()
                            .createMatch(formIds[i]!, rowID);
                      }
                    }
                  }
                }
              }
              setState(() {
                isLoading = false;
              });
              //////////////////////////////////////////////////////////////////////////////////////
            } else {
              if (datesG.isEmpty || datesS.isEmpty) {
                showDatePopUp(context);
              } else {
                setState(() {
                  isLoading = true;
                });
                int rowIDS = 0;
                int numberOfChangesS = 0;

                if (widget.update == true) {
                  numberOfChangesS = await UserServices().updateForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed',
                      widget.formID);
                  if (numberOfChangesS == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsG = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIdsG.isNotEmpty) {
                      for (int i = 0; i < formIdsG.length; i++) {
                        MatchingsServices()
                            .createMatch(widget.formID, formIdsG[i]!);
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  rowIDS = await UserServices().createNewForm(
                      id,
                      'seeker',
                      seekerModel.formItemControllerS.text,
                      seekerModel.categoryS,
                      datesS,
                      seekerModel.forWhoS,
                      'Not Completed');
                  rows = rowIDS;
                  if (rowIDS <= 0) {
                    setState(() {
                      isLoading = false;
                    });
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsG = await MatchingsServices()
                        .checkMatching(
                            'giver',
                            seekerModel.formItemControllerS.text,
                            seekerModel.categoryS,
                            datesS,
                            city);

                    //make match if exists
                    if (formIdsG.isNotEmpty) {
                      for (int i = 0; i < formIdsG.length; i++) {
                        MatchingsServices().createMatch(rowIDS, formIdsG[i]!);
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                }

                int rowIDG = 0;
                int numberOfChangesG = 0;

                if (widget.update == true) {
                  numberOfChangesG = await UserServices().updateForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed',
                      widget.formID);

                  if (numberOfChangesG == 0) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'No changes made.',
                        isError: false, isWarning: true);
                  } else if (numberOfChanges == -1) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context, 'Form doesn\'t exist!');
                  } else if (numberOfChanges == -3) {
                    setState(() {
                      isLoading = false;
                    });
                    showDatabasePopup(context,
                        'There was a problem updating form. Please try again later..!');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsS = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIdsS.isNotEmpty) {
                      for (int i = 0; i < formIdsS.length; i++) {
                        MatchingsServices()
                            .createMatch(formIdsS[i]!, widget.formID);
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  rowIDG = await UserServices().createNewForm(
                      id,
                      'giver',
                      donorModel.formItemControllerD.text,
                      donorModel.categoryD,
                      datesG,
                      null,
                      'Not Completed');
                  rows = rowIDG;
                  if (rowIDG <= 0) {
                    //error creating form
                    showDatabasePopup(context,
                        'There was a problem creating the form. \n \nPlease try again later.');
                  } else {
                    //check match
                    String city = await UserServices().getCity(id);
                    List<int?> formIdsS = await MatchingsServices()
                        .checkMatching(
                            'seeker',
                            donorModel.formItemControllerD.text,
                            donorModel.categoryD,
                            datesG,
                            city);

                    //make match if exists
                    if (formIdsS.isNotEmpty) {
                      for (int i = 0; i < formIdsS.length; i++) {
                        MatchingsServices().createMatch(formIdsS[i]!, rowIDG);
                      }
                    }
                  }
                }
                numberOfChanges = numberOfChangesS + numberOfChangesG;
              }
            }
            // ignore: use_build_context_synchronously

            if (numberOfChanges <= 0 && widget.update == true) {
              setState(() {
                isLoading = false;
              });
            } else {
              if (widget.update == true) {
                setState(() {
                  isLoading = false;
                });
                showDatabasePopup(context, 'Form updated successfully!',
                    isError: false, onOKPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppHomePage()));
                });
              } else {
                if (rows > 0) {
                  setState(() {
                    isLoading = false;
                  });
                  showDatabasePopup(context, 'Form created successfully!',
                      isError: false, onOKPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppHomePage()));
                  });
                }
              }
            }
          }
          /////////////////////////////////////////////////////////////////////////
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 20.0, bottom: 20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              backgroundColor: HapisColors.lgColor4,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      if (isLoading)
        Positioned.fill(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ),
    ]);
  }
}

class FormSubHeading extends StatelessWidget {
  final String subtext;
  final double fontSize;
  const FormSubHeading({
    super.key,
    required this.subtext,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              subtext,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: HapisColors.lgColor1),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ],
    );
  }
}
