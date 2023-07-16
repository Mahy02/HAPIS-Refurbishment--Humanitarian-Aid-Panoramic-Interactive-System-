import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/reusable_widgets/liquid_galaxy/user_elevated_button.dart';

/// `UserComponent is for each user in the users page
/// it is a [StatefulWidget] that simply returns `UserElevatedButton`
class UserComponent extends StatefulWidget {
  final UsersModel user;
  final String type;
  final double height;
  final double width;
  const UserComponent({
    super.key,
    required this.user,
    required this.type,
    required this.height,
    required this.width
  });

  @override
  State<UserComponent> createState() => _UserComponentState();
}

class _UserComponentState extends State<UserComponent> {
  @override
  Widget build(BuildContext context) {
    return UserElevatedButton(
      elevatedButtonContent:
          ' ${widget.user.firstName!} ${widget.user.lastName!}',
      type: widget.type,
      user: widget.user,
      height: widget.height,
      width: widget.width,
    );
  }
}
