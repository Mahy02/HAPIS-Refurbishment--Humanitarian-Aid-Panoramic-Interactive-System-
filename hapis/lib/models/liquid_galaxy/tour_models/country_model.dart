import 'package:hapis/models/liquid_galaxy/tour_models/city_model.dart';

class CountryModel {
  String name;
  double longitude;
  double latitude;
  List<CityModelTour> cities;

  CountryModel(this.name, this.longitude, this.latitude, this.cities);
}
