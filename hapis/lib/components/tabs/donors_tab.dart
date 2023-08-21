import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/filter_provider.dart';
import '../../providers/user_provider.dart';
import '../../reusable_widgets/filter_modal.dart';
import '../../reusable_widgets/no_component.dart';
import '../../reusable_widgets/user_app_component.dart';
import '../../services/db_services/users_services.dart';

/// This file contains the implementation of the `DonorsTab` widget, which represents
/// a tab in an app for displaying a list of seekers. It includes search and filter
/// functionalities for users.
/// 
/// 


/// Represents a tab for displaying donors with search and filter functionalities.
class DonorsTab extends StatefulWidget {
  const DonorsTab({Key? key}) : super(key: key);

  @override
  State<DonorsTab> createState() => _DonorsTabState();
}

class _DonorsTabState extends State<DonorsTab> {
  ///`searchController` for the search functionality
  TextEditingController searchController = TextEditingController();

  List<UserModel> usersList = [];

  ///`filteredUsersList` for all filtered users from `searchController
  List<UserModel> filteredUsersList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getUsers();
    });
  }

 /// Fetches user data and initializes the list of donors.
  void getUsers() async {
    UserAppProvider userProvider =
        Provider.of<UserAppProvider>(context, listen: false);

    userProvider.clearDataApp();
    await UserServices().getUsersInfo('giver', context);

    setState(() {
      usersList = userProvider.giversApp;
      filteredUsersList = userProvider.giversApp;
      print("donors length");
      print(usersList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: buildMobileLayout(), tabletBody: buildTabletLayout());
  }
 
  /// Updates the filtered users list based on the provided search query.
  void performSearch(String query) {
    setState(() {
      filteredUsersList = usersList.where((user) {
        final String firstName = user.firstName!.toLowerCase();
        final String lastName = user.lastName!.toLowerCase();
        final String city = user.city!.toLowerCase();
        final String cat = user.category!.toLowerCase();
        final String item = user.item!.toLowerCase();
        final String country = user.country!.toLowerCase();
        final String userName = user.userName!.toLowerCase();

        return firstName.contains(query.toLowerCase()) ||
            lastName.contains(query.toLowerCase()) ||
            city.contains(query.toLowerCase()) ||
            country.contains(query.toLowerCase()) ||
            cat.contains(query.toLowerCase()) ||
            item.contains(query.toLowerCase()) ||
            userName.contains(query.toLowerCase());
      }).toList();
    });
  }
/// Updates the filtered users list based on the selected filter settings.
  void performFilter() {
    FilterSettingsModel filterSettingsModel =
        Provider.of<FilterSettingsModel>(context, listen: false);
    setState(() {
      filteredUsersList = usersList.where((user) {
        final String city = user.city!.toLowerCase();
        final String country = user.country!.toLowerCase();
        final String cat = user.category!.toLowerCase();
        final String date = user.multiDates!;

        final bool matchesCity = filterSettingsModel.selectedCities.isEmpty ||
            filterSettingsModel.selectedCities.any(
                (selectedCity) => city.contains(selectedCity.toLowerCase()));

        final bool matchesCountry =
            filterSettingsModel.selectedCountries.isEmpty ||
                filterSettingsModel.selectedCountries.any((selectedCountry) =>
                    country.contains(selectedCountry.toLowerCase()));

        final bool matchesCategory =
            filterSettingsModel.selectedCategories.isEmpty ||
                filterSettingsModel.selectedCategories.any((selectedCategory) =>
                    cat.contains(selectedCategory.toLowerCase()));

        return matchesCity && matchesCountry && matchesCategory;

      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildMobileLayout() {
    final noSeekers = filteredUsersList.isEmpty;
    print(filteredUsersList.length);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) {
              /// calling `performSearch` to search for value entered on change of `searchController
              performSearch(value);
            },
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: HapisColors.lgColor3,
              ),
              suffixIcon: GestureDetector(
                child: const Icon(
                  Icons.filter_list_rounded,
                  size: 30,
                  color: HapisColors.lgColor3,
                ),
                onTap: () {
                  showFilterModal();
                },
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: HapisColors.lgColor3, width: 1.5),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          noSeekers
              ? const Expanded(
                  child: NoComponentWidget(
                      displayText: 'You don\'t have any donors',
                      icon: Icons.person),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsersList.length,
                    itemBuilder: (context, index) {
                      final UserModel user = filteredUsersList[index];

                      return Column(
                        children: [
                          UserAppComponent(
                            user: user,
                            expansionTitleFontSize: 22,
                            imageHeight:
                                MediaQuery.of(context).size.height * 0.03,
                            imageWidth:
                                MediaQuery.of(context).size.width * 0.07,
                            userImageHeight:
                                MediaQuery.of(context).size.height * 0.1,
                            userImageWidth:
                                MediaQuery.of(context).size.width * 0.1,
                            headerFontSize: 18,
                            textFontSize: 16,
                            containerHeight:
                                MediaQuery.of(context).size.height * 0.8,
                            containerWidth:
                                MediaQuery.of(context).size.width * 0.9,
                            isMobile: true,
                            friendshipSize: 20,
                          ),
                          const Divider(
                            height: 3,
                            thickness: 0.5,
                            color: HapisColors.lgColor3,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          )
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    final noSeekers = filteredUsersList.isEmpty;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) {
              /// calling `performSearch` to search for value entered on change of `searchController
              performSearch(value);
            },
            style: const TextStyle(
              fontSize: 22,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 40,
                color: HapisColors.lgColor3,
              ),
              suffixIcon: GestureDetector(
                child: const Icon(
                  Icons.filter_list_rounded,
                  size: 50,
                  color: HapisColors.lgColor3,
                ),
                onTap: () {
                  showFilterModal();
                },
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: HapisColors.lgColor3, width: 1.5),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          noSeekers
              ? const Expanded(
                  child: NoComponentWidget(
                      displayText: 'You don\'t have any donors',
                      icon: Icons.person),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsersList.length,
                    itemBuilder: (context, index) {
                      final UserModel user = filteredUsersList[index];

                      return Column(
                        children: [
                          UserAppComponent(
                            user: user,
                            expansionTitleFontSize: 28,
                            imageHeight:
                                MediaQuery.of(context).size.height * 0.04,
                            imageWidth:
                                MediaQuery.of(context).size.width * 0.03,
                            userImageHeight:
                                MediaQuery.of(context).size.height * 0.15,
                            userImageWidth:
                                MediaQuery.of(context).size.width * 0.15,
                            headerFontSize: 30,
                            textFontSize: 28,
                            containerHeight:
                                MediaQuery.of(context).size.height * 1.5,
                            containerWidth:
                                MediaQuery.of(context).size.width * 0.8,
                            isMobile: false,
                            friendshipSize: 40,
                          ),
                          const Divider(
                            height: 3,
                            thickness: 0.5,
                            color: HapisColors.lgColor3,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          )
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

 /// Displays a bottom sheet modal for applying filter settings.
  ///
  /// This method fetches a list of cities and countries using the `UserServices`
  /// class and displays a bottom sheet modal containing a `FilterModal` widget.
  /// The `FilterModal` widget allows the user to select filter criteria such as
  /// cities, countries, and categories. Once the filtering is applied, the `onFiltered`
  /// callback triggers the `performFilter` method to update the list of filtered users.
  ///
  /// The modal is displayed with rounded corners and takes into account the safe
  /// area of the device. It is scrollable and adapts to the content's height.
  ///
  /// It is important to note that this method should be called within a context
  /// that has access to the `BuildContext` of the widget hierarchy.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// showFilterModal();
  /// ```
  void showFilterModal() async {
    List<Map<String, String>> citiesAndCountries =
        await UserServices().getCitiesAndCountries();
    List<String> cities =
        citiesAndCountries.map((item) => item['city']!).toList();

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return FilterModal(
          cities: cities,
          onFiltered: () {
            performFilter();
          },
        );
      },
    );
  }
}
