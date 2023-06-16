import 'package:flutter/material.dart';
import 'package:hapis/services/SSH_services.dart';
import 'package:hapis/services/kml/file_services.dart';
import 'package:provider/provider.dart';

import '../models/kml/look_at_model.dart';
import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';

///This class is responsible for the connection between the LG machine and the Tablet application
///The LG service needed such as shutting down the LG, Rebooting the LG, Relaunching the LG
///As well as common functionalities assosiated with the LG such as Fly-to, orbit, sending KML files, Clearing KML, Shwowing Ballons and Logos

class LgService {
  /// An instance of [SSHprovider] class

 final SSHprovider _sshData;
LgService(this._sshData);


  /// An instance of [FileService] class
  final _fileService= FileService();

  /// Property that defines the master rig url.
  final String _url = 'http://lg1:81';

  /// Property that defines number of screens. Defaults to `5`.
  int screenAmount = 5;

  /// Lg order:  if 5 => 5 4 1 2 3   if 3 => 3 1 2

  /// Property that defines the logo slave screen number according to the [screenAmount] property. (Most left screen)
  int get logoScreen {
    if (screenAmount == 1) {
      return 1;
    }

    // Gets the most left screen.
    return (screenAmount / 2).floor() + 2;
  }

  /// Property that defines the balloon slave screen number according to the [screenAmount] property. (Most right screen)
  int get balloonScreen {
    if (screenAmount == 1) {
      return 1;
    }

    // Gets the most right screen.
    return (screenAmount / 2).floor() + 1;
  }


  ///Liquid Galaxy Services:
  ///-----------------------
  

  /// Relaunching the Liquid Galaxy System:
  /// We used to type: --lg-relaunch  in terminal

  Future<void> relaunch() async {
    final pw = _sshData.client.passwordOrKey;
    final user = _sshData.client.username;

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _sshData.client
            .execute("'/home/$user/bin/lg-relaunch' > /home/$user/log.txt");
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Reboots the Liquid Galaxy system.
  /// We used to write sudo reboot  in the terminal, but we need a way to add the password and the LG number too here
  Future<void> reboot() async {
     final pw = _sshData.client.passwordOrKey;
    final user = _sshData.client.username;
    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _sshData
            .execute("'/home/$user/bin/lg-reboot' > /home/$user/log.txt");
        //OR:  
        //OR:   'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"'
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Shuts down the Liquid Galaxy system.
  Future<void> shutdown() async {
     final pw = _sshData.client.passwordOrKey;
    final user = _sshData.client.username;

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _sshData.execute(
            "'/home/$user/bin/lg-poweroff' > /home/$user/log.txt");

        //OR: 'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"'
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }


 

  /// Puts the given [content] into the `/tmp/query.txt` file.
  Future<void> query(String content) async {
    await _sshData.execute('echo "$content" > /tmp/query.txt');
  }

  ///Fly to functionality:
  /// Command to fly to a certain location: 'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt'
  /// Uses the [query] method to fly to some place in Google Earth according to the given [lookAt].
  /// See [LookAtModel].
  Future<void> flyTo(LookAtModel lookAt) async {
    await query('flytoview=${lookAt.linearTag}');
  }


  ///Orbit functionality: 
  /// Uses the [query] method to play some tour in Google Earth according to  the given [tourName].
  /// Command: 'echo "playtour=Orbit" > /tmp/query.txt'
  Future<void> startTour(String tourName) async {
    await query('playtour=$tourName');
  }

  /// Uses the [query] method to stop all tours in Google Earth.
  Future<void> stopTour() async {
    await query('exittour=true');
  }


  ///KML services:
  ///------------

  ///Visualizing the uploaded KML on LG command: echo "http://lg1:81/$projectname.kml" > /var/www/html/kmls.txt'
  ///Sending tour to the Google Earth using the KML file and the tourname ex: Orbit
   /// Sends and starts a `tour` into the Google Earth.
  Future<void> sendTour(String tourKml, String tourName) async {
    final fileName = '$tourName.kml';

    final kmlFile = await _fileService.createFile(fileName, tourKml);
    await _sshData.uploadKml(kmlFile.path);

    await _sshData
        .execute('echo "\n$_url/$fileName" >> /var/www/html/kmls.txt');
  }

}

/*
In this file, we would add all LG functionalities we might need including the following:
 1. connecting with LG
 2. shutting down LG
 3. Rebooting LG
 4. Relaunch the LG
 
 5. Fly to functionality 
 6. orbit functionality

 7. determing logo screen (top left screen for the slaves)
 8. determing bubble screen (right screen for the slaves)
 9. set logos
 
 10. send KML to the LG system
 11. clearing KML files
 12. send KML to slave

 13. set refresh
 14. reset refresh 
*/
