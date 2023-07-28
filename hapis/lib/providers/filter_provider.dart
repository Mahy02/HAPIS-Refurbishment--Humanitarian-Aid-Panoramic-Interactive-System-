import 'package:flutter/foundation.dart';

///This is a [Provider] class of [FilterSettingsModel] that extends [ChangeNotifier]

///They all have setters and getters
///We have [toggleSelectedCountry] method to add or remove an item from `_selectedCountries`
///We have [toggleSelectedCity] method to add or remove an item from `_selectedCities`
///We have [toggleSelectedCategory] method to add or remove an item from `_selectedCategories`
///We have [clearFilters] method to clear filter

class FilterSettingsModel extends ChangeNotifier {
  String? _selectedDate;
  Set<String> _selectedCountries = {};
  Set<String> _selectedCities = {};
  Set<String> _selectedCategories = {};

  String? get selectedDate => _selectedDate;
  Set<String> get selectedCountries => _selectedCountries;
  Set<String> get selectedCities => _selectedCities;
  Set<String> get selectedCategories => _selectedCategories;

  void setSelectedDate(String? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void toggleSelectedCountry(String country) {
    if (_selectedCountries.contains(country)) {
      _selectedCountries.remove(country);
    } else {
      _selectedCountries.add(country);
    }
    notifyListeners();
  }

  void toggleSelectedCity(String city) {
    if (_selectedCities.contains(city)) {
      _selectedCities.remove(city);
    } else {
      _selectedCities.add(city);
    }
    notifyListeners();
  }

  void toggleSelectedCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedDate = null;
    _selectedCountries.clear();
    _selectedCities.clear();
    _selectedCategories.clear();
    notifyListeners();
  }
}
