import 'package:flutter/material.dart';
import 'package:hapis/services/db_services/users_services.dart';

import '../models/db_models/users_model.dart';
import '../reusable_widgets/cityComponent.dart';
import '../reusable_widgets/no_component.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});
  

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<String>>(
      future: UserServices().getCities(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching cities'));
        } 
        final citiesList = snapshot.data ?? [];
        final noCities = citiesList.isEmpty;
        return noCities!
            ? const NoComponentWidget(
                displayText: 'Sorry, there are no Cities available',
                icon: Icons.location_city_outlined)
            : Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  itemCount: citiesList.length,
                  itemBuilder: (context, index) {
                    //final EventModel event = eventDraftsList[index];
                    final UsersModel city = citiesList[index];
                    // print(event.category);
                    return CityComponent(
                        key: const ValueKey("cityComponent"), User: city,);
                  },
                ),
              );
      },
    );
  }
}

