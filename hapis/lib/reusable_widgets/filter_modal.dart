// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hapis/providers/filter_provider.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'filter_card_component.dart';

/// This is a custom Widget `FilterModal` which displays the filter UI bottom sheetmodal and the components inside
/// It takes as input required List of [cities] for displaying cities
/// as well as a call back function to what will happen when user press on filter or cancel [onFiltered]
/// It returns a [ResponsiveLayout] for mobile and tablet layouts
class FilterModal extends StatefulWidget {
  final List<String> cities;
  final VoidCallback onFiltered;
  const FilterModal(
      {super.key, required this.cities, required this.onFiltered});

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  double _value = 2023;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: buildMobileModal(), tabletBody: buildTabletModal());
  }

  ///This function returns a [Widget] which is a [Container] of the modal and its content in mobile view
  Widget buildMobileModal() {
    FilterSettingsModel filterSetting =
        Provider.of<FilterSettingsModel>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.filter_list,
                color: HapisColors.lgColor3,
              )),
          const Text(
            'Country',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 100,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return FilterCard(
                  itemName: countries[index],
                  fontSize: 14,
                );
              },
            ),
          ),
          const Text(
            'City',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 100,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: widget.cities.length,
              itemBuilder: (context, index) {
                bool isSelected =
                    filterSetting.selectedCities.contains(widget.cities[index]);
                return FilterCard(
                  itemName: widget.cities[index],
                  fontSize: 14,
                );
              },
            ),
          ),
          const Text(
            'Catgeory',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 100,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                return FilterCard(
                  itemName: categoryList[index],
                  fontSize: 14,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: HapisColors.lgColor4),
                onPressed: () {
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: const Text('FILTER'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: HapisColors.lgColor2),
                onPressed: () {
                  filterSetting.clearFilters();
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: const Text('CLEAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///This function returns a [Widget] which is a [Container] of the modal and its content in tablet view
  Widget buildTabletModal() {
    FilterSettingsModel filterSetting =
        Provider.of<FilterSettingsModel>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.filter_list,
                color: HapisColors.lgColor3,
                size: 50,
              )),
          const Text(
            'Country',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 150,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return FilterCard(
                  itemName: countries[index],
                  fontSize: 22,
                );
              },
            ),
          ),
          const Text(
            'City',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 150,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: widget.cities.length,
              itemBuilder: (context, index) {
                bool isSelected =
                    filterSetting.selectedCities.contains(widget.cities[index]);
                return FilterCard(
                  itemName: widget.cities[index],
                  fontSize: 22,
                );
              },
            ),
          ),
          const Text(
            'Catgeory',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 150,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                return FilterCard(
                  itemName: categoryList[index],
                  fontSize: 22,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: HapisColors.lgColor4),
                onPressed: () {
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: const Text(
                  'FILTER',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: HapisColors.lgColor2),
                onPressed: () {
                  filterSetting.clearFilters();
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: const Text(
                  'CLEAR',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
