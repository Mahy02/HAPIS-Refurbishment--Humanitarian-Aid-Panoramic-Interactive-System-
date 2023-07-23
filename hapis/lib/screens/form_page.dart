import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';

import 'package:hapis/providers/form_provider.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';

import 'package:provider/provider.dart';

import '../providers/date_selection.dart';
import '../reusable_widgets/date_day_component.dart';
import '../reusable_widgets/date_time_component.dart';
import '../reusable_widgets/drop_down_list_component.dart';
import '../reusable_widgets/text_form_field.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  List<DateSelectionModel> _selectedDatesSeeker = [];
  List<DateSelectionModel> _selectedDatesGiver = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(isLg: false, appBarText: ''),
      drawer: buildDrawer(context, false),
      body: Consumer2<FormProvider, FormProvider>(
        builder:
            (BuildContext context, donorModel, seekerModel, Widget? child) {
          int typeIndexDonor = typeList.indexOf(donorModel.type);
          int categoryIndexDonor = categoryList.indexOf(donorModel.category);
          //int forWhoIndexDonor = forWhoList.indexOf(donorModel.forWho);

          int typeIndexSeeker = typeList.indexOf(seekerModel.type);
          int categoryIndexSeeker = categoryList.indexOf(seekerModel.category);
          int forWhoIndexSeeker = forWhoList.indexOf(seekerModel.forWho);

          return ResponsiveLayout(
              mobileBody: buildMobileLayout(
                  donorModel,
                  seekerModel,
                  typeIndexSeeker,
                  typeIndexDonor,
                  categoryIndexDonor,
                  categoryIndexSeeker,
                  forWhoIndexSeeker),
              tabletBody: buildTabletLayout(
                  donorModel,
                  seekerModel,
                  typeIndexSeeker,
                  typeIndexDonor,
                  categoryIndexDonor,
                  categoryIndexSeeker,
                  forWhoIndexSeeker));
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
      int forWhoIndexSeeker) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
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
                                donorModel.type = value;
                                seekerModel.type = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ],
                      ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Seeking for Who?',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
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
                                  seekerModel.forWho = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Choose the category you are seeking',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
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
                                  seekerModel.category = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Choose the category you wish to donate',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
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
                                  donorModel.category = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Specify the item you wish to donate',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        Column(
                          children: [
                            TextFormFieldWidget(
                              key: const ValueKey("item"),
                              textController: donorModel.formItemController,
                              hint: 'Enter the item you prefer',
                              maxLength: 50,
                              isHidden: false,
                              isSuffixRequired: true,
                              label: 'Item ',
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Specify the item you need',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        Column(
                          children: [
                            TextFormFieldWidget(
                              key: const ValueKey("item"),
                              textController: seekerModel.formItemController,
                              hint: 'Enter the item you prefer',
                              maxLength: 50,
                              isHidden: false,
                              isSuffixRequired: true,
                              label: 'Item ',
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext:
                              'Specify all available dates for you to pick the item you need',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        CircleAvatar(
                          backgroundColor: HapisColors.lgColor3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedDatesSeeker.add(DateSelectionModel());
                              });
                            },
                          ),
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
                      if (donorModel.type == 'both')
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext:
                              'Specify all available dates for you to donate the item',
                          fontSize: 18,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
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
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
    );
  }

  Widget buildTabletLayout(
      FormProvider donorModel,
      FormProvider seekerModel,
      int typeIndexSeeker,
      int typeIndexDonor,
      int categoryIndexDonor,
      int categoryIndexSeeker,
      int forWhoIndexSeeker) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
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
                                donorModel.type = value;
                                seekerModel.type = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ],
                      ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Seeking for Who?',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
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
                                  seekerModel.forWho = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Choose the category you are seeking',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
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
                                  seekerModel.category = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Choose the category you wish to donate',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
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
                                  donorModel.category = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Specify the item you wish to donate',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        Column(
                          children: [
                            TextFormFieldWidget(
                              key: const ValueKey("item"),
                              textController: donorModel.formItemController,
                              hint: 'Enter the item you prefer',
                              maxLength: 50,
                              isHidden: false,
                              isSuffixRequired: true,
                              label: 'Item ',
                              fontSize: 22,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext: 'Specify the item you need',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        Column(
                          children: [
                            TextFormFieldWidget(
                              key: const ValueKey("item"),
                              textController: seekerModel.formItemController,
                              hint: 'Enter the item you prefer',
                              maxLength: 50,
                              isHidden: false,
                              isSuffixRequired: true,
                              label: 'Item ',
                              fontSize: 20,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext:
                              'Specify all available dates for you to pick the item you need',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        CircleAvatar(
                          backgroundColor: HapisColors.lgColor3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedDatesSeeker.add(DateSelectionModel());
                              });
                            },
                          ),
                        ),
                      if (donorModel.type == 'seeker' ||
                          donorModel.type == 'both')
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
                      if (donorModel.type == 'both')
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        const FormSubHeading(
                          subtext:
                              'Specify all available dates for you to donate the item',
                          fontSize: 25,
                        ),
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
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
                      if (donorModel.type == 'giver' ||
                          donorModel.type == 'both')
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
    );
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
