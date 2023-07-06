import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/reusable_widgets/user_elevated_button.dart';

class UserComponent extends StatefulWidget {
  final UsersModel user;
  final String type;
  const UserComponent({
    super.key,
    required this.user,
    required this.type,
  });

  @override
  State<UserComponent> createState() => _UserComponentState();
}

class _UserComponentState extends State<UserComponent> {
  @override
  Widget build(BuildContext context) {
    return UserElevatedButton(
      elevatedButtonContent:
          ' ${widget.user.firstName!} ${widget.user.lastName!}', type: widget.type, user: widget.user,
    );
  }
}
