import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/screens/google_signup.dart';
import 'package:hapis/services/db_services/users_services.dart';
import 'package:image_picker/image_picker.dart';
import '../location_and_maps/location_controller.dart';
import '../models/db_models/user_model.dart';
import '../reusable_widgets/back_button.dart';
import '../reusable_widgets/drop_down_list_component.dart';
import '../reusable_widgets/text_form_field.dart';
import 'dart:io';
import '../utils/database_popups.dart';

/// This is the SignUp Page for allowing users to Sign up or edit their profile
/// * [update] - Required [bool] for knowing whether user wants to update their info or Sign up as new user
class SignUpPage extends StatefulWidget {
  final GoogleSignInAccount? googleUser;
  final UserModel? normalUser;
  final bool update;
  final bool isGoogle;

  const SignUpPage(
      {super.key,
      this.googleUser,
      this.normalUser,
      required this.update,
      required this.isGoogle});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String? _country;
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController(text: countries[0]);
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  File? image;

  @override
  void initState() {
    super.initState();

    if (widget.normalUser != null) {
      UserModel user = widget.normalUser!;
      _usernameController.text = user.userName!;
      _firstNameController.text = user.firstName!;
      _lastNameController.text = user.lastName!;
      _countryController.text = user.country!;
      _cityController.text = user.city!;
      _addressController.text = user.addressLocation!;
      _phoneNumberController.text = user.phoneNum!;
      _country = user.country!;

      image = File(user.imagePath ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    int countryIndex = countries.indexOf(_countryController.text);

    return GetBuilder<LocationController>(
      init: LocationController(),
      builder: (controller) {
        return ResponsiveLayout(
            mobileBody: buildMobile(controller, countryIndex),
            tabletBody: buildTablet(controller, countryIndex));
      },
    );
  }

  Widget buildMobile(LocationController controller, int countryIndex) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: HapisColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.googleUser != null
                          ? widget.googleUser!.photoUrl != null
                              ? NetworkImage(widget.googleUser!.photoUrl!)
                              : const AssetImage(
                                  'assets/images/defaultuser.png',
                                ) as ImageProvider<Object>
                          : const AssetImage(
                              'assets/images/defaultuser.png',
                            ) as ImageProvider<Object>,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.black.withOpacity(
                            0.5), // Set the color to semi-transparent white
                        onPressed: () {
                          // TODO: Implement changing profile picture functionality
                          _handleUploadImageButtonTap();
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    if (widget.googleUser != null)
                      Text('Hi ${widget.googleUser!.displayName}',
                          style: TextStyle(fontSize: 22)),
                    if (widget.normalUser != null)
                      Text('Hi ${widget.normalUser!.userName}',
                          style: TextStyle(fontSize: 22)),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      key: const ValueKey("username"),
                      textController: _usernameController,
                      hint: 'Enter a unique username',
                      maxLength: 12,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'UserName ',
                      fontSize: 16,
                    ),
                    if (widget.update == false)
                      TextFormFieldWidget(
                        key: const ValueKey("firstname"),
                        textController: _firstNameController,
                        hint: 'Enter your First Name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'First Name ',
                        fontSize: 16,
                      ),
                    if (widget.update == true)
                      TextFormFieldWidget(
                        key: const ValueKey("firstname"),
                        textController: _firstNameController,
                        hint: 'Enter your First Name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'First Name ',
                        fontSize: 16,
                        enabled: false,
                      ),
                    if (widget.update == false)
                      TextFormFieldWidget(
                        key: const ValueKey("lastname"),
                        textController: _lastNameController,
                        hint: 'Enter your last name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'Last Name ',
                        fontSize: 16,
                      ),
                    if (widget.update == true)
                      TextFormFieldWidget(
                        key: const ValueKey("lastname"),
                        textController: _lastNameController,
                        hint: 'Enter your last name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'Last Name ',
                        fontSize: 16,
                        enabled: false,
                      ),
                    DropDownListWidget(
                      key: const ValueKey("countries"),
                      fontSize: 16,
                      items: countries,
                      selectedValue: countryIndex != -1
                          ? countries[countryIndex]
                          : countries[0],
                      hinttext: 'Country',
                      onChanged: (value) {
                        setState(() {
                          _countryController.text = value;
                          _country = value;
                        });
                      },
                    ),
                    TextFormFieldWidget(
                      key: const ValueKey("city"),
                      textController: _cityController,
                      hint: 'Enter your city',
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'city ',
                      fontSize: 16,
                    ),
                    TextFormFieldWidget(
                      key: const ValueKey("phonenum"),
                      textController: _phoneNumberController,
                      hint: 'Enter your phone number',
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'Phone number ',
                      fontSize: 16,
                    ),
                    TextFormFieldWidget(
                      key: const ValueKey("add_location"),
                      textController: _addressController,
                      hint: 'Enter your address',
                      maxLength: 300,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'Address Location',
                      fontSize: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HapisColors.lgColor1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () async {
                            try {
                              await controller.getCurrentLocation();
                            } catch (e) {
                              // Handle any exceptions that might occur during the execution of getCurrentLocation()
                              print(e);
                            }
                          },
                          child: const Text(
                            'Get Current \n Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HapisColors.lgColor1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () async {
                            _addressController.text =
                                controller.currentLocation ?? '';
                          },
                          child: const Text(
                            'Show \n Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HapisColors.lgColor4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          if (widget.update != true) {
                            final result = await UserServices().createNewUser(
                              userID: widget.googleUser!.id,
                              userName: _usernameController.text,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              counrty: _countryController.text,
                              city: _cityController.text,
                              phoneNum: _phoneNumberController.text,
                              address: _addressController.text,
                              email: widget.googleUser!.email,
                            );

                            if (result >= 0) {
                              showDatabasePopup(context,
                                  'User created successfully! \n\nNow try signing in to HAPIS!',
                                  isError: false, onOKPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GoogleSignUp()));
                              });
                            } else if (result == -1) {
                              showDatabasePopup(context,
                                  'UserName already exists, please try a different username');
                            } else if (result == -2) {
                              showDatabasePopup(
                                  context, 'User already exists!');
                            } else if (result == -3) {
                              showDatabasePopup(context,
                                  'There was a problem creating user. Please try again later..');
                            }
                          } else {
                            //update google user without password
                            if (widget.isGoogle) {
                              final numberOfChanges =
                                  await UserServices().updateUser(
                                widget.normalUser!.userID!,
                                _usernameController.text,
                                _firstNameController.text,
                                _lastNameController.text,
                                _countryController.text,
                                _cityController.text,
                                _phoneNumberController.text,
                                _addressController.text,
                                widget.normalUser!.email!,
                                //  null
                              );
                              if (numberOfChanges == 0) {
                                showDatabasePopup(context, 'No changes made.',
                                    isError: false, isWarning: true);
                              } else if (numberOfChanges == -1) {
                                showDatabasePopup(
                                    context, 'User doesn\'t exist!');
                              } else if (numberOfChanges == -2) {
                                showDatabasePopup(context,
                                    'UserName already exists, please try a different username');
                              } else if (numberOfChanges == -3) {
                                showDatabasePopup(context,
                                    'There was a problem updating user. Please try again later..');
                              } else {
                                showDatabasePopup(
                                    context, 'User Info updated successfully!',
                                    isError: false, onOKPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppHomePage()));
                                });
                              }
                            } else {
                              //update normal user with password
                              final numberOfChanges = await UserServices()
                                  .updateUser(
                                      widget.normalUser!.userID!,
                                      _usernameController.text,
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _countryController.text,
                                      _cityController.text,
                                      _phoneNumberController.text,
                                      _addressController.text,
                                      widget.normalUser!.email!
                                     
                                      );
                              if (numberOfChanges == 0) {
                                showDatabasePopup(context, 'No changes made.',
                                    isError: false, isWarning: true);
                              } else if (numberOfChanges == -1) {
                                showDatabasePopup(
                                    context, 'User doesn\'t exist!');
                              } else if (numberOfChanges == -2) {
                                showDatabasePopup(context,
                                    'UserName already exists, please try a different username');
                              } else if (numberOfChanges == -3) {
                                showDatabasePopup(context,
                                    'There was a problem updating user. Please try again later..');
                              } else {
                                showDatabasePopup(
                                    context, 'User Info updated successfully!',
                                    isError: false, onOKPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppHomePage()));
                                });
                              }
                            }
                          }
                        },
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTablet(LocationController controller, int countryIndex) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: HapisColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButtonWidget(
                isTablet: true,
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.googleUser != null
                          ? widget.googleUser!.photoUrl != null
                              ? NetworkImage(widget.googleUser!.photoUrl!)
                              : const AssetImage(
                                  'assets/images/defaultuser.png',
                                ) as ImageProvider<Object>
                          : const AssetImage(
                              'assets/images/defaultuser.png',
                            ) as ImageProvider<Object>,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.black.withOpacity(
                            0.5), // Set the color to semi-transparent white
                        onPressed: () {
                          // TODO: Implement changing profile picture functionality
                          _handleUploadImageButtonTap();
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    if (widget.googleUser != null)
                      Text('Hi ${widget.googleUser!.displayName}',
                          style: TextStyle(fontSize: 30)),
                    if (widget.normalUser != null)
                      Text('Hi ${widget.normalUser!.userName}',
                          style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      key: const ValueKey("username"),
                      textController: _usernameController,
                      hint: 'Enter a unique username',
                      maxLength: 12,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'UserName ',
                      fontSize: 25,
                    ),
                    if (widget.update == false)
                      TextFormFieldWidget(
                        key: const ValueKey("firstname"),
                        textController: _firstNameController,
                        hint: 'Enter your First Name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'First Name ',
                        fontSize: 25,
                      ),
                    if (widget.update == true)
                      TextFormFieldWidget(
                        key: const ValueKey("firstname"),
                        textController: _firstNameController,
                        hint: 'Enter your First Name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'First Name ',
                        fontSize: 25,
                        enabled: false,
                      ),
                    if (widget.update == false)
                      TextFormFieldWidget(
                        key: const ValueKey("lastname"),
                        textController: _lastNameController,
                        hint: 'Enter your last name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'Last Name ',
                        fontSize: 25,
                      ),
                    if (widget.update == true)
                      TextFormFieldWidget(
                        key: const ValueKey("lastname"),
                        textController: _lastNameController,
                        hint: 'Enter your last name',
                        maxLength: 12,
                        isHidden: false,
                        isSuffixRequired: true,
                        label: 'Last Name ',
                        fontSize: 25,
                        enabled: false,
                      ),
                    DropDownListWidget(
                      key: const ValueKey("countries"),
                      fontSize: 25,
                      items: countries,
                      selectedValue: countryIndex != -1
                          ? countries[countryIndex]
                          : countries[0],
                      hinttext: 'Country',
                      onChanged: (value) {
                        setState(() {
                          _countryController.text = value;
                          _country = value;
                        });
                      },
                    ),
                    TextFormFieldWidget(
                      key: const ValueKey("city"),
                      textController: _cityController,
                      hint: 'Enter your city',
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'city ',
                      fontSize: 25,
                    ),
                    TextFormFieldWidget(
                      key: const ValueKey("phonenum"),
                      textController: _phoneNumberController,
                      hint: 'Enter your phone number',
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'Phone number ',
                      fontSize: 25,
                    ),
                    TextFormFieldWidget(
                      key: const ValueKey("add_location"),
                      textController: _addressController,
                      hint: 'Enter your address',
                      maxLength: 300,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'Address Location',
                      fontSize: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HapisColors.lgColor1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () async {
                            try {
                              await controller.getCurrentLocation();
                            } catch (e) {
                              // Handle any exceptions that might occur during the execution of getCurrentLocation()
                              print(e);
                            }
                          },
                          child: const Text(
                            'Get Current \n Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HapisColors.lgColor1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () async {
                            _addressController.text =
                                controller.currentLocation ?? '';
                          },
                          child: const Text(
                            'Show \n Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HapisColors.lgColor4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          if (widget.update != true) {
                            final result = await UserServices().createNewUser(
                              userID: widget.googleUser!.id,
                              userName: _usernameController.text,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              counrty: _countryController.text,
                              city: _cityController.text,
                              phoneNum: _phoneNumberController.text,
                              address: _addressController.text,
                              email: widget.googleUser!.email,
                            );

                            if (result >= 0) {
                              showDatabasePopup(context,
                                  'User created successfully! \n\nNow try signing in to HAPIS!',
                                  isError: false, onOKPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GoogleSignUp()));
                              });
                            } else if (result == -1) {
                              showDatabasePopup(context,
                                  'UserName already exists, please try a different username');
                            } else if (result == -2) {
                              showDatabasePopup(
                                  context, 'User already exists!');
                            } else if (result == -3) {
                              showDatabasePopup(context,
                                  'There was a problem creating user. Please try again later..');
                            }
                          } else {
                            //update google user without password
                            if (widget.isGoogle) {
                              final numberOfChanges = await UserServices()
                                  .updateUser(
                                      widget.normalUser!.userID!,
                                      _usernameController.text,
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _countryController.text,
                                      _cityController.text,
                                      _phoneNumberController.text,
                                      _addressController.text,
                                      widget.normalUser!.email!
                                      //  null
                                      );
                              if (numberOfChanges == 0) {
                                showDatabasePopup(context, 'No changes made.',
                                    isError: false, isWarning: true);
                              } else if (numberOfChanges == -1) {
                                showDatabasePopup(
                                    context, 'User doesn\'t exist!');
                              } else if (numberOfChanges == -2) {
                                showDatabasePopup(context,
                                    'UserName already exists, please try a different username');
                              } else if (numberOfChanges == -3) {
                                showDatabasePopup(context,
                                    'There was a problem updating user. Please try again later..');
                              } else {
                                showDatabasePopup(
                                    context, 'User Info updated successfully!',
                                    isError: false, onOKPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppHomePage()));
                                });
                              }
                            } else {
                              
                              final numberOfChanges = await UserServices()
                                  .updateUser(
                                      widget.normalUser!.userID!,
                                      _usernameController.text,
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _countryController.text,
                                      _cityController.text,
                                      _phoneNumberController.text,
                                      _addressController.text,
                                      widget.normalUser!.email!
                                     
                                      );
                              if (numberOfChanges == 0) {
                                showDatabasePopup(context, 'No changes made.',
                                    isError: false, isWarning: true);
                              } else if (numberOfChanges == -1) {
                                showDatabasePopup(
                                    context, 'User doesn\'t exist!');
                              } else if (numberOfChanges == -2) {
                                showDatabasePopup(context,
                                    'UserName already exists, please try a different username');
                              } else if (numberOfChanges == -3) {
                                showDatabasePopup(context,
                                    'There was a problem updating user. Please try again later..');
                              } else {
                                showDatabasePopup(
                                    context, 'User Info updated successfully!',
                                    isError: false, onOKPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppHomePage()));
                                });
                              }
                            }
                          }
                        },
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<XFile?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile;
  }

  void _handleUploadImageButtonTap() async {
    final imageFile = await pickImage(ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
    }
  }
}
