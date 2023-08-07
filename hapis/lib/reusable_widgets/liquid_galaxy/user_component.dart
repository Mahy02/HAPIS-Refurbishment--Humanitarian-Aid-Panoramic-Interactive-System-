import 'package:flutter/material.dart';
import 'package:hapis/models/liquid_galaxy/balloon_models/users_model.dart';
import 'package:hapis/reusable_widgets/liquid_galaxy/user_elevated_button.dart';

/// `UserComponent is for each user in the users page
/// it is a [StatefulWidget] that simply returns `UserElevatedButton`
/// It takes the following paramters
///   -   `user` [UsersModel] to be displayed
///   -   `type` for the user type
///   -   `height` and `width` for adapting to different scales and being responsive
class UserComponent extends StatefulWidget {
  final UsersModel user;
  final String type;
  final double height;
  final double width;
  final double? imageHeight;
  final double? imageWidth;
  const UserComponent(
      {super.key,
      required this.user,
      required this.type,
      required this.height,
      required this.width, this.imageHeight, this.imageWidth});

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
      imageHeight: widget.imageHeight,
      imageWidth: widget.imageWidth,
    );
  }
}
