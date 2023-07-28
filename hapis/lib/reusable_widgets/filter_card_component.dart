import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:provider/provider.dart';

import '../providers/filter_provider.dart';

/// This is a custome widget [FilterCard] that displays the items component in the Filter modal
/// It has required [itemName] as well as [fontSize]
/// It returns an [ElevatedButton] which its background is toggled on pressed and value is saved through a provider [FilterSettingsModel]
class FilterCard extends StatefulWidget {
  final String itemName;
  final double fontSize;

  const FilterCard({
    super.key,
    required this.itemName,
    required this.fontSize,
  });

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  @override
  Widget build(BuildContext context) {
    FilterSettingsModel filterSetting =
        Provider.of<FilterSettingsModel>(context, listen: false);
    bool _isSelected;

    if (countries.contains(widget.itemName)) {
      _isSelected = filterSetting.selectedCountries.contains(widget.itemName);
    } else if (categoryList.contains(widget.itemName)) {
      _isSelected = filterSetting.selectedCategories.contains(widget.itemName);
    } else {
      _isSelected = filterSetting.selectedCities.contains(widget.itemName);
    }

    return ElevatedButton(
      onPressed: () {
        if (countries.contains(widget.itemName)) {
          filterSetting.toggleSelectedCountry(widget.itemName);
        } else if (categoryList.contains(widget.itemName)) {
          filterSetting.toggleSelectedCategory(widget.itemName);
        } else {
          filterSetting.toggleSelectedCity(widget.itemName);
        }
        setState(() {
          if (countries.contains(widget.itemName)) {
            _isSelected =
                filterSetting.selectedCountries.contains(widget.itemName);
          } else if (categoryList.contains(widget.itemName)) {
            _isSelected =
                filterSetting.selectedCategories.contains(widget.itemName);
          } else {
            _isSelected =
                filterSetting.selectedCities.contains(widget.itemName);
          }
        });
      },
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor:
              _isSelected ? HapisColors.primary : HapisColors.lgColor1),
      child: Text(
        widget.itemName,
        style: TextStyle(fontSize: widget.fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
