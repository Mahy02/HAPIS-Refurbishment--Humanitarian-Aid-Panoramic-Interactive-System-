import 'package:flutter/material.dart';
import 'package:hapis/providers/filter_provider.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'filter_card_component.dart';

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
          const Text(
            'Month',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _value,
            min: 2023,
            max: 2040,
            divisions: (2040 - 2023),
            onChanged: (double newValue) {
              setState(() {
                filterSetting.setSelectedDate(newValue.toString());
                _value = newValue;
              });
            },
            label: '${_value.toInt()}',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: HapisColors.lgColor4),
                onPressed: () {
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: Text('FILTER'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: HapisColors.lgColor2),
                onPressed: () {
                  filterSetting.clearFilters();
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: Text('CLEAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          const Text(
            'Month',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _value,
            min: 2023,
            max: 2040,
            divisions: (2040 - 2023),
            onChanged: (double newValue) {
              setState(() {
                filterSetting.setSelectedDate(newValue.toString());
                _value = newValue;
              });
            },
            label: '${_value.toInt()}',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: HapisColors.lgColor4),
                onPressed: () {
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: Text(
                  'FILTER',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: HapisColors.lgColor2),
                onPressed: () {
                  filterSetting.clearFilters();
                  widget.onFiltered();
                  Navigator.pop(context);
                },
                child: Text(
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
