import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/reusable_widgets/sub_text.dart';
import 'package:hapis/utils/drawer.dart';

import '../../constants.dart';
import '../../models/db_models/users_model.dart';
import '../../reusable_widgets/liquid_galaxy/user_component.dart';
import '../../reusable_widgets/no_component.dart';


/// this is the [Seekers] that include all seekers retrieved from the database
/// It has a default [HAPISAppBar] and calls [buildDrawer] for the [Drawer]
/// [GridView] was used for the cities to display 3 items per row
/// The widget returns a [UserComponent] for each user in the database

class Seekers extends StatefulWidget {
  final List<UsersModel> seekersList;
  final String city;

  const Seekers({Key? key, required this.seekersList, required this.city})
      : super(key: key);
  @override
  State<Seekers> createState() => _SeekersState();
}

class _SeekersState extends State<Seekers> {
  ///`searchController` for the search functionality
  TextEditingController searchController = TextEditingController();

  ///`filteredSeekersList` for all filtered seekers from `searchController
  List<UsersModel> filteredSeekersList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getSeekers();
    });
  }

  void getSeekers() {
    setState(() {
      filteredSeekersList = widget.seekersList;
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
                fontSize: 30,
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
                    width: 1.5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: HapisColors.lgColor3, width: 1.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SubText(subTextContent: 'Seekers In ${widget.city} '),
          ),
          Flexible(
            child: filteredSeekersList.isEmpty
                ? const NoComponentWidget(
                    displayText: 'Sorry, there are no users available',
                    icon: Icons.people_alt)
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 50, left: 50),
                    child: GridView.builder(
                      itemCount: filteredSeekersList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Display 3 items per row
                        crossAxisSpacing: 100.0,
                        mainAxisSpacing: 100.0,
                      ),
                      itemBuilder: (context, index) {
                        final UsersModel user = filteredSeekersList[index];

                        return UserComponent(
                            key: const ValueKey("userComponent"),
                            user: user,
                            type: 'seeker');
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
      filteredSeekersList = widget.seekersList.where((user) {
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
