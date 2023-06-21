import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hapis/models/users_model.dart';

class CityComponent extends StatelessWidget {
   final UsersModel User;
  const CityComponent({super.key, required this.User});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}