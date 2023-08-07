import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/liquid_galaxy/balloon_models/users_model.dart';
import '../../providers/liquid_galaxy/connection_provider.dart';
import '../../reusable_widgets/back_button.dart';
import '../../reusable_widgets/liquid_galaxy/connection_indicator.dart';
import '../../reusable_widgets/liquid_galaxy/user_component.dart';
import '../../reusable_widgets/no_component.dart';
import '../../reusable_widgets/sub_text.dart';

/// this is the [Givers] page that include all givers retrieved from the database
/// It has a default [HAPISAppBar] and calls [buildDrawer] for the [Drawer]
/// [GridView] was used for the cities to display 3 items per row
/// The widget returns a [UserComponent] for each user in the database

class Givers extends StatefulWidget {
  final List<UsersModel> giversList;
  final String city;
  const Givers({Key? key, required this.giversList, required this.city})
      : super(key: key);

  @override
  State<Givers> createState() => _GiversState();
}

class _GiversState extends State<Givers> {
  ///`searchController` for the search functionality
  TextEditingController searchController = TextEditingController();

  ///`filteredGiversList` for all filtered givers from `searchController
  List<UsersModel> filteredGiversList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getGivers();
    });
  }

  void getGivers() {
    setState(() {
      filteredGiversList = widget.giversList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HAPISAppBar(
          appBarText: '',
          isLg: true,
        ),
        drawer: ResponsiveLayout(
            mobileBody: buildDrawer(context, true, 18, 16),
            tabletBody: buildDrawer(context, true, 24, 20)),
        body: ResponsiveLayout(
            mobileBody: buildMobileLayout(), tabletBody: buildTabletLayout()));
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

  Widget buildMobileLayout() {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return Column(
      children: [
        BackButtonWidget(
          isTablet: false,
        ),
        ConnectionIndicator(isConnected: connection.isConnected),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              performSearch(value);
            },
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: const InputDecoration(
              hintText: 'Search for a user',
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
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SubText(
            subTextContent: 'Donors In ${widget.city} ',
            fontSize: 18,
          ),
        ),
        Flexible(
          child: widget.giversList.isEmpty
              ? const NoComponentWidget(
                  displayText: 'Sorry, there are no users available',
                  icon: Icons.people_alt)
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 20, left: 20, bottom: 20),
                  child: GridView.builder(
                    itemCount: filteredGiversList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Display 3 items per row
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                            childAspectRatio: 1.2),
                    itemBuilder: (context, index) {
                      final UsersModel user = filteredGiversList[index];

                      return UserComponent(
                        key: const ValueKey("userComponent"),
                        user: user,
                        type: 'giver',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.4,
                        imageHeight: MediaQuery.of(context).size.height * 0.03,
                        imageWidth: MediaQuery.of(context).size.width * 0.065,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildTabletLayout() {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return Column(
      children: [
        BackButtonWidget(
          isTablet: true,
        ),
        ConnectionIndicator(isConnected: connection.isConnected),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 50, right: 50),
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
                borderSide: BorderSide(color: HapisColors.lgColor3, width: 1.5),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SubText(
            subTextContent: 'Donors In ${widget.city} ',
            fontSize: 35,
          ),
        ),
        Flexible(
          child: widget.giversList.isEmpty
              ? const NoComponentWidget(
                  displayText: 'Sorry, there are no users available',
                  icon: Icons.people_alt)
              : Padding(
                  padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
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
                        key: const ValueKey("userComponent"),
                        user: user,
                        type: 'giver',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.15,
                        imageHeight: MediaQuery.of(context).size.height * 0.01,
                        imageWidth: MediaQuery.of(context).size.width * 0.03,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
