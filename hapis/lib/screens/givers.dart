import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';

import '../constants.dart';
import '../models/db_models/users_model.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/sub_text.dart';
import '../reusable_widgets/user_component.dart';

class Givers extends StatefulWidget {
  final List<UsersModel> giversList;
  final String city;
  //const Givers({super.key, required this.giversList, required this.city});
  const Givers({Key? key, required this.giversList, required this.city})
      : super(key: key);

  @override
  State<Givers> createState() => _GiversState();
}

class _GiversState extends State<Givers> {
  TextEditingController searchController = TextEditingController();

  List<UsersModel> filteredGiversList = [];

  @override
  void initState() {
    super.initState();
    //print("initialization");
    Future.delayed(Duration.zero, () {
      getGivers();
    });
  }

  void getGivers() {
    //print("get seekers called");
    setState(() {
      filteredGiversList = widget.giversList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(appBarText: ''),
      drawer: buildDrawer(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 50, right: 50),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                performSearch(value);
              },
              style: const TextStyle(
                fontSize: 30, // Increase the font size to your desired value
              ),
              decoration: const InputDecoration(
                hintText: 'Search for a user',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 50,
                  color: HapisColors.lgColor3,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.5, // Replace with the desired border color
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HapisColors.lgColor3, width: 1.5
                      // Replace with the desired border color when focused
                      ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SubText(subTextContent: 'Donors In ${widget.city} '),
          ),
          Flexible(
            child: widget.giversList.isEmpty
                ? const NoComponentWidget(
                    displayText: 'Sorry, there are no users available',
                    icon: Icons.people_alt)
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 50, left: 50),
                    child: GridView.builder(
                      itemCount: filteredGiversList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Display 3 items per row
                        crossAxisSpacing: 100.0,
                        mainAxisSpacing: 100.0,
                      ),
                      itemBuilder: (context, index) {
                        final UsersModel user = filteredGiversList[index];

                        return UserComponent(
                            key: const ValueKey("userComponent"), user: user);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void performSearch(String query) {
    setState(() {
      filteredGiversList = widget.giversList.where((user) {
        final String userFirstName = user.firstName!.toLowerCase();
        final String userLastName = user.lastName!.toLowerCase();
        return userFirstName.contains(query.toLowerCase()) ||
            userLastName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
