import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/services/db_services/users_services.dart';
import 'package:hapis/utils/drawer.dart';

import '../../constants.dart';
import '../../responsive/responsive_layout.dart';
import '../../reusable_widgets/liquid_galaxy/cityComponent.dart';
import '../../reusable_widgets/no_component.dart';

/// this is the [CitiesPage] that include all cities retrieved from the database
/// It has a default [HAPISAppBar] and calls [buildDrawer] for the [Drawer]
/// [GridView] was used for the cities to display two items per row
/// The widget returns a [CityComponent] for each city in the database

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  /// `buttonColors` to define colors for each button
  final List<Color> buttonColors = [
    HapisColors.lgColor1,
    HapisColors.lgColor2,
    HapisColors.lgColor3,
    HapisColors.lgColor4
  ];

  ///`searchController` for the search functionality
  TextEditingController searchController = TextEditingController();

  ///`citiesList` for the all the cities
  List<Map<String, String>> citiesList = [];

  ///`filteredCitiesList` for all filtered cities from `searchController
  List<Map<String, String>> filteredCitiesList = [];

  @override
  void initState() {
    super.initState();
    getCities();
  }

  ///`getCities` to get the cities and countries from the database and set the `citiesList` and `filteredCitiesList`
  Future<void> getCities() async {
    final List<Map<String, String>> cities =
        await UserServices().getCitiesAndCountries();
    setState(() {
      citiesList = cities;
      filteredCitiesList = cities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(appBarText: '', isLg: true,),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, true, 18, 16),
          tabletBody: buildDrawer(context, true, 24, 20)),
      body: ResponsiveLayout(
        mobileBody: buildMobileLayout(),
        tabletBody: buildTabletLayout(),
      ),
    );
  }

  void performSearch(String query) {
    setState(() {
      filteredCitiesList = citiesList.where((city) {
        final String cityName = city['city']!.toLowerCase();
        final String countryName = city['country']!.toLowerCase();
        return cityName.contains(query.toLowerCase()) ||
            countryName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildMobileLayout() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 50, right: 50),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              /// calling `performSearch` to search for value entered on change of `searchController
              performSearch(value);
            },
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: const InputDecoration(
              hintText: 'Search for a city',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: HapisColors.lgColor3,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HapisColors.lgColor3, width: 1.5),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredCitiesList.isEmpty
              ? const NoComponentWidget(
                  displayText: 'Sorry, there are no Cities available',
                  icon: Icons.location_city_outlined)
              : Padding(
                  padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
                  child: GridView.builder(
                    itemCount: filteredCitiesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Display two items per row
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemBuilder: (context, index) {
                      final String city = filteredCitiesList[index]['city']!;
                      final String country =
                          filteredCitiesList[index]['country']!;

                      final Color buttonColor =
                          buttonColors[index % buttonColors.length];

                      return CityComponent(
                        key: const ValueKey("cityComponent"),
                        city: city,
                        country: country,
                        buttonColor: buttonColor,
                        imageHeight: MediaQuery.of(context).size.height * 0.1,
                        imageWidth: MediaQuery.of(context).size.height * 0.1,
                        fontSize: 16,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildTabletLayout() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 50, right: 50),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              /// calling `performSearch` to search for value entered on change of `searchController
              performSearch(value);
            },
            style: const TextStyle(
              fontSize: 30,
            ),
            decoration: const InputDecoration(
              hintText: 'Search for a city',
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
                borderSide: BorderSide(color: HapisColors.lgColor3, width: 1.5),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredCitiesList.isEmpty
              ? const NoComponentWidget(
                  displayText: 'Sorry, there are no Cities available',
                  icon: Icons.location_city_outlined)
              : Padding(
                  padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
                  child: GridView.builder(
                    itemCount: filteredCitiesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Display two items per row
                      crossAxisSpacing: 100.0,
                      mainAxisSpacing: 100.0,
                    ),
                    itemBuilder: (context, index) {
                      final String city = filteredCitiesList[index]['city']!;
                      final String country =
                          filteredCitiesList[index]['country']!;

                      final Color buttonColor =
                          buttonColors[index % buttonColors.length];

                      return CityComponent(
                        key: const ValueKey("cityComponent"),
                        city: city,
                        country: country,
                        buttonColor: buttonColor,
                        imageHeight: MediaQuery.of(context).size.height * 0.2,
                        imageWidth: MediaQuery.of(context).size.height * 0.4,
                        fontSize: 35,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
