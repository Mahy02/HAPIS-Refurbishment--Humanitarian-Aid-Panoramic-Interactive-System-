import 'package:flutter/material.dart';
import 'package:hapis/services/SSH_services.dart';
import 'package:provider/provider.dart';

import '../providers/connection_provider.dart';

///This class is responsible for the connection between the LG machine and the Tablet application
///The LG service needed such as shutting down the LG, Rebooting the LG, Relaunching the LG
///As well as common functionalities assosiated with the LG such as Fly-to, orbit, sending KML files, Clearing KML, Shwowing Ballons and Logos

class LgService {
  /// An instance of [SSHService] class
  final sshService = SSHService();


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

  /// Relaunching the Liquid Galaxy System:
  /// We used to type: --lg-relaunch  in terminal

  Future<void> relaunch() async {
    final pw = sshService.client.passwordOrKey;
    final user = sshService.client.username;

     for (var i = screenAmount; i >= 1; i--) {
        try {
        
    await sshService.client.execute(
         "'/home/$user/bin/lg-relaunch' > /home/$user/log.txt");
        }catch (e) {
        // ignore: avoid_print
        print(e);
      }
     }

  }

//   Future<void> relaunch() async {
//     final pw = _sshClient.passwordOrKey;
//     final user = _sshClient.username;

//     for (var i = screenAmount; i >= 1; i--) {
//       try {
//         final relaunchCommand = """RELAUNCH_CMD="\\
// if [ -f /etc/init/lxdm.conf ]; then
//   export SERVICE=lxdm
// elif [ -f /etc/init/lightdm.conf ]; then
//   export SERVICE=lightdm
// else
//   exit 1
// fi
// if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
//   echo $pw | sudo -S service \\\${SERVICE} start
// else
//   echo $pw | sudo -S service \\\${SERVICE} restart
// fi
// " && sshpass -p $pw ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

//         await _sshService
//             .execute('"/home/$user/bin/lg-relaunch" > /home/$user/log.txt');
//         await _sshService.execute(relaunchCommand);
//       } catch (e) {
//         // ignore: avoid_print
//         print(e);
//       }
//     }
//   }



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
