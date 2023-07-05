import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';

import '../constants.dart';
import '../models/db_models/users_model.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/user_component.dart';

class Seekers extends StatefulWidget {
  final List<UsersModel> seekersList;
  final String city;
  const Seekers({super.key, required this.seekersList, required this.city});

  @override
  State<Seekers> createState() => _SeekersState();
}

class _SeekersState extends State<Seekers> {
  final List<Color> buttonColors = [
    HapisColors.lgColor1,
    HapisColors.lgColor2,
    HapisColors.lgColor3,
    HapisColors.lgColor4
  ];

  TextEditingController searchController = TextEditingController();

  //List<Map<String, String>> giversList = [];
  List<Map<String, String>> filteredGiversList = [];

  @override
  void initState() {
    super.initState();
    getGivers();
  }

  Future<void> getGivers() async {
    setState(() {
      // citiesList = cities;
      //filteredCitiesList = cities;
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
                // performSearch(value);
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
          Flexible(
            child: widget.seekersList.isEmpty
                ? const NoComponentWidget(
                    displayText: 'Sorry, there are no users available',
                    icon: Icons.people_alt)
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 50, left: 50),
                    child: GridView.builder(
                      // itemCount: citiesList.length,
                      itemCount: widget.seekersList.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Display 3 items per row
                        crossAxisSpacing: 100.0,
                        mainAxisSpacing: 100.0,
                      ),
                      itemBuilder: (context, index) {
                        UsersModel user = widget.seekersList[index];
                      
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

  // void performSearch(String query) {
  //   setState(() {
  //     filteredCitiesList = citiesList.where((city) {
  //       final String cityName = city['city']!.toLowerCase();
  //       final String countryName = city['country']!.toLowerCase();
  //       return cityName.contains(query.toLowerCase()) ||
  //           countryName.contains(query.toLowerCase());
  //     }).toList();
  //   });
  // }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
