

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:provider/provider.dart';

import '../../providers/liquid_galaxy/connection_provider.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../reusable_widgets/app_bar.dart';
import '../../reusable_widgets/sub_text.dart';
import '../../reusable_widgets/text_form_field.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/drawer.dart';
import '../../utils/show_connection_error.dart';


///This is we configure the connection between the LG and the tablet app
///We need a username, password, master IP address and port number as well as number of screens for valid connection
///We update the data in the [Connectionprovider] Class and if data is valid we establish a connection from the [SSHprovider]
///The Configruation widget use the custom [HAPISAppBar] and calls [buildDrawer] for the [Drawer]
///It uses [Consumer] to save the data in the [Connectionprovider]


class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {

  /// `form key` for our configuration form
  final _formKey = GlobalKey<FormState>();

  /// `is loading` to Track the loading state
  bool _isLoading = false; 

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(
        appBarText: '',
      ),
      drawer: Drawer(
      
          child: buildDrawer(context)),
      body: SingleChildScrollView(
        child: Consumer<Connectionprovider>(
          builder: (BuildContext context, model, Widget? child) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                   
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 50,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SubText(
                              subTextContent: 'LG Configuration Settings'),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Connection Status: ',
                            style: TextStyle(
                              fontSize: 38,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              color: HapisColors.lgColor1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Text(
                            model.isConnected == true
                                ? "Connected"
                                : "Not Connected",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              color: model.isConnected == true
                                  ? HapisColors.lgColor4
                                  : HapisColors.lgColor2,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'LG User Name',
                                    key: const ValueKey("username"),
                                    textController: model.userNameController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'LG Password',
                                    key: const ValueKey("lgpass"),
                                    textController:
                                        model.passwordOrKeyController,
                                    isSuffixRequired: true,
                                    isHidden: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    key: const ValueKey("ip"),
                                    label: 'LG Master IP address',
                                    textController: model.hostController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'LG Port Number',
                                    key: const ValueKey("port"),
                                    textController: model.portController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'Number of LG screens',
                                    key: const ValueKey("lgscreens"),
                                    textController:
                                        model.screenAmountController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ElevatedButton(
                          onPressed: () async {
                            /// checking first if form is valid
                            if (_formKey.currentState!.validate()) {
                              ///calling `saveData` from the provider to save the data entered by the user
                              Provider.of<Connectionprovider>(context,
                                      listen: false)
                                  .saveData(
                                model.userNameController,
                                model.hostController,
                                model.passwordOrKeyController,
                                model.portController,
                                model.screenAmountController,
                                model.isConnected,
                              );
                            
                            }

                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);


                            ///start the loading process by setting `isloading` to true
                            setState(() {
                              _isLoading = true; 
                            });

                            /// Call the init function to set up the SSH client with the connection data
                            String? result = await sshData.init(context);

                           
                            ///checking on the connection status:
                            if (result == '') {
                              setState(() {
                              
                                model.isConnected = true;
                              });
                              ///If connected, the logos should appear by calling `setLogos` from the `LGService` calss
                              LgService(sshData).setLogos();
                            } else {
                              ///show an error message
                              showConnectionError(context, result!);
                            }

                             ///stop the loading process by setting `isloading` to false
                            setState(() {
                              _isLoading = false; 
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: HapisColors.lgColor4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            //  minimumSize: ,
                          ),
                          child: const Text(
                            'Connect to LG',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 42,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isLoading)
                    /// Show the loading indicator if `_isLoading` is true
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.3,
                      //color: Color.fromARGB(126, 234, 234, 234),
                      child: const CircularProgressIndicator(
                        color: HapisColors.accent,
                        backgroundColor: HapisColors.lgColor3,
                        semanticsLabel: 'Loading',
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
