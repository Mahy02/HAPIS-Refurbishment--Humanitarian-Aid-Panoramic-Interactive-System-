import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/services/db_services/users_services.dart';
import 'package:hapis/utils/drawer.dart';

import '../constants.dart';
import '../reusable_widgets/cityComponent.dart';
import '../reusable_widgets/no_component.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  final List<Color> buttonColors = [
    HapisColors.lgColor1,
    HapisColors.lgColor2,
    HapisColors.lgColor3,
    HapisColors.lgColor4
  ];

  TextEditingController searchController = TextEditingController();

  List<Map<String, String>> citiesList = [];
  List<Map<String, String>> filteredCitiesList = [];

  @override
  void initState() {
    super.initState();
    getCities();
  }

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
          Expanded(
            child: filteredCitiesList.isEmpty
                // child: FutureBuilder<List<Map<String, String>>>(
                //   future: UserServices().getCitiesAndCountries(),
                //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //     if (snapshot.hasError) {
                //       return const Center(child: Text('Error fetching cities'));
                //     }
                //     final citiesList = snapshot.data ?? [];
                //     final noCities = citiesList.isEmpty;
                //     return noCities!
                ? const NoComponentWidget(
                    displayText: 'Sorry, there are no Cities available',
                    icon: Icons.location_city_outlined)
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 50, left: 50),
                    child: GridView.builder(
                      // itemCount: citiesList.length,
                      itemCount: filteredCitiesList.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Display two items per row
                        crossAxisSpacing: 100.0,
                        mainAxisSpacing: 100.0,
                      ),
                      itemBuilder: (context, index) {
                        // final String city = citiesList[index];
                        // final String city = citiesList[index]['city'];
                        // final String country = citiesList[index]['country'];
                        final String city = filteredCitiesList[index]['city']!;
                        final String country =
                            filteredCitiesList[index]['country']!;

                        final Color buttonColor =
                            buttonColors[index % buttonColors.length];
                        // print(event.category);
                        print(city);
                        print(country);
                        print("before pressing city");
                        return CityComponent(
                          key: const ValueKey("cityComponent"),
                          city: city,
                          country: country,
                          buttonColor: buttonColor,
                        );
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
}
