import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hapis/constants.dart';
//import 'package:image_picker/image_picker.dart';
import '../helpers/api.dart';
import '../models/place_autocomplete.dart';
import '../reusable_widgets/drop_down_list_component.dart';
import '../reusable_widgets/location_list_title.dart';
import '../reusable_widgets/text_form_field.dart';

class SignUpPage extends StatefulWidget {
  final GoogleSignInAccount user;
  const SignUpPage({super.key, required this.user});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  //for place autocomplete:
  /// Makes a request to the Google Places API autocomplete with the given query.
  /// Updates [placePredictions] with the results.
  Future<void> placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      '/maps/api/place/autocomplete/json', //unencoder path
      {
        "input": query, //query parameter
        "key": apiKey,
      },
    );

    ///for get request:
    String? response = await Api.fetchUrl(uri);

    /// Parse the response and update [placePredictions] if there are any predictions.
    if (response != null) {
      PlaceAutoCompleteResponse result =
          PlaceAutoCompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  String? _username;
  String? _firstName;
  String? _lastName;
  String? _city;
  String? _country;
  String? _address;
  String? _phoneNumber;

  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String _selectedLocationInput = '';

  @override
  Widget build(BuildContext context) {
    int countryIndex = countries.indexOf(_countryController.text);
    //int countryIndex = countries.indexOf('Afghanistan');
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
                      backgroundImage: widget.user.photoUrl != null
                          ? NetworkImage(widget.user.photoUrl!)
                          : const AssetImage(
                              'assets/images/defaultuser.png',
                            ) as ImageProvider<Object>,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          // TODO: Implement changing profile picture functionality
                          //  _handleUploadImageButtonTap();
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Text('Hi ${widget.user.displayName}',
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
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'UserName ',
                      fontSize: 16,
                    ),

                    TextFormFieldWidget(
                      key: const ValueKey("firstname"),
                      textController: _firstNameController,
                      hint: 'Enter your First Name',
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'First Name ',
                      fontSize: 16,
                    ),

                    TextFormFieldWidget(
                      key: const ValueKey("lastname"),
                      textController: _lastNameController,
                      hint: 'Enter your last name',
                      maxLength: 50,
                      isHidden: false,
                      isSuffixRequired: true,
                      label: 'Last Name ',
                      fontSize: 16,
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
                      key: const ValueKey("location"),
                      textController: _addressController,
                      label: 'Address Location ',
                      hint: '',
                      isHidden: false,
                      isSuffixRequired: true,
                      onChanged: (value) {
                        // setState(() {
                        //   _selectedLocationInput = value;
                        // });
                        placeAutoComplete(value);
                      },
                      fontSize: 16,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Color.fromARGB(255, 215, 215, 215),
                    ),
                    //created own components for suggestion
                    //to show the results:
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                        itemCount: placePredictions.length,
                        itemBuilder: (context, index) => LocationListTitle(
                          onSelect: (value) {
                            setState(() {
                              _selectedLocationInput = value;

                              placePredictions.clear();
                            });
                            _addressController.text = value;
                          },
                          location: placePredictions[index].description!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: HapisColors.lgColor4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // if (_formKey.currentState?.validate()) {
                    //   _formKey.currentState.save();
                    //   // TODO: Implement submitting data to database
                    // }
                  },
                  child: Text(
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
      ),
    );
  }

  //  Future<XFile?> pickImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);
  //   return pickedFile;
  // }

  // void _handleUploadImageButtonTap() async {
  //   final imageFile = await pickImage(ImageSource.gallery);

  //   final image = Provider.of<DetailsFormDataProvider>(context, listen: false);

  //   if (imageFile != null) {
  //     setState(() {
  //       image.eventImage = File(imageFile.path);
  //       image.imagePath = imageFile.path;
  //     });
  //   }
  // }
}
