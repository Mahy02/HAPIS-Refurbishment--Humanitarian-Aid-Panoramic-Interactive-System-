import 'package:hapis/models/liquid_galaxy/tour_models/userlocation_model.dart';

class CityModelTour {
  String name;
  double longitude;
  double latitude;
  List<UserLocationModel> userLocations;

  CityModelTour(this.name, this.longitude, this.latitude, this.userLocations);
}