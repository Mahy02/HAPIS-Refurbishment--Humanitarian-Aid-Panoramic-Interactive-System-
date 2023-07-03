import 'package:hapis/services/kml/file_services.dart';
import '../models/kml/KMLModel.dart';
import '../models/kml/look_at_model.dart';
import '../models/kml/screen_overlay_model.dart';
import '../providers/ssh_provider.dart';

///This class is responsible for the connection between the LG machine and the Tablet application
///The LG service needed such as shutting down the LG, Rebooting the LG, Relaunching the LG
///As well as common functionalities assosiated with the LG such as Fly-to, orbit, sending KML files, Clearing KML, Shwowing Ballons and Logos

class LgService {
  /// An instance of [SSHprovider] class
  final SSHprovider _sshData;
  LgService(this._sshData);

  /// An instance of [FileService] class
  final _fileService = FileService();

  /// Property that defines the master rig url.
  final String _url = 'http://lg1:81';

  /// Property that defines number of screens. Defaults to `5`.
  int screenAmount = 5;

  /// Lg order:  if 5 => 5 4 1 2 3   if 3 => 3 1 2

  /// Property that defines the logo slave screen number according to the [screenAmount] property. (Most left screen)
  int get logoScreen {
    int sA = int.parse(getScreenAmount()!);
    if (sA == 1) {
      return 1;
    }

    // Gets the most left screen.
    return (sA / 2).floor() + 2;
  }

  /// Property that defines the balloon slave screen number according to the [screenAmount] property. (Most right screen)
  int get balloonScreen {
    int sA = int.parse(getScreenAmount()!);
    if (sA == 1) {
      return 1;
    }

    // Gets the most right screen.
    return (sA / 2).floor() + 1;
  }

  ///Liquid Galaxy Services:
  ///-----------------------

  /// Gets the Liquid Galaxy rig screen amount. Returns a [String] that represents the screen amount.
  String? getScreenAmount() {
    int numberOfScreen = _sshData.numberOfScreens!;
    screenAmount = numberOfScreen;
    String? result = numberOfScreen.toString();

    return result;
  }

  /// Relaunching the Liquid Galaxy System:
  /// We used to type: --lg-relaunch  in terminal
  Future<void> relaunch() async {
    final pw = _sshData.passwordOrKey;
    final user = _sshData.username;
    //final pw = _sshData.passwordOrKey;
    //client!.passwordOrKey;
    //final user = _sshData.client!.username;

    // if (await _sshData.client!.isConnected()) {
    //   print("check connection");
    // }

    print("inside relaunch function");
    print(pw);
    print(user);

    final result = await getScreenAmount();
    if (result != null) {
      screenAmount = int.parse(result);
    }

    print(screenAmount);
    for (var i = screenAmount; i >= 1; i--) {
      print(i);
      try {
        print(user);
        final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $pw | sudo -S service \\\${SERVICE} start
else
  echo $pw | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $pw ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        await _sshData.client!
            .execute("'/home/$user/bin/lg-relaunch' > /home/$user/log.txt");

        await _sshData.client!.execute(relaunchCommand);
        print("after execute");
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Reboots the Liquid Galaxy system.
  /// We used to write sudo reboot  in the terminal, but we need a way to add the password and the LG number too here
  Future<void> reboot() async {
    // final pw = _sshData.client!.passwordOrKey;
    final pw = _sshData.passwordOrKey;
    final user = _sshData.username;
    // final pw = _sshData.passwordOrKey;
    // final user = _sshData.client!.username;

    final result = await getScreenAmount();
    if (result != null) {
      screenAmount = int.parse(result);
    }

    print(screenAmount);

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _sshData
            .execute('sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');

        //OR:   .execute("'/home/$user/bin/lg-reboot' > /home/$user/log.txt");
        //OR:   'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"'
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Shuts down the Liquid Galaxy system.
  Future<void> shutdown() async {
    //final pw = _sshData.client!.passwordOrKey;
    final pw = _sshData.passwordOrKey;
    final user = _sshData.username;
    // final pw = _sshData.passwordOrKey;
    // final user = _sshData.client!.username;

    final result = await getScreenAmount();
    if (result != null) {
      screenAmount = int.parse(result);
    }

    print(screenAmount);

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _sshData.execute(
            'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"');

        //OR: "'/home/$user/bin/lg-poweroff' > /home/$user/log.txt"
        //OR: 'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"'
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Puts the given [content] into the `/tmp/query.txt` file.
  Future<void> query(String content) async {
    print("inside query");
    await _sshData.execute('echo "$content" > /tmp/query.txt');
    //await _sshData.execute('chmod 777 /tmp/query.txt && echo "$content" > /tmp/query.txt');
    //await _sshData.execute('echo "$content" > ~/query.txt');

    print("after execute query");
    print(content);
  }

  ///Fly to functionality:
  /// Command to fly to a certain location: 'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt'
  /// Uses the [query] method to fly to some place in Google Earth according to the given [lookAt].
  /// See [LookAtModel].
  Future<void> flyTo(LookAtModel lookAt) async {
    print("inside fly to fn");
    print(lookAt.latitude);
    print(lookAt.linearTag);
    await query('flytoview=${lookAt.linearTag}');
  }

  ///Orbit functionality:
  /// Uses the [query] method to play some tour in Google Earth according to  the given [tourName].
  /// Command: 'echo "playtour=Orbit" > /tmp/query.txt'
  Future<void> startTour(String tourName) async {
    print("inside start tour");
    await query('playtour=$tourName');
    print("after query start tour");
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
    print("inside send tour in LG functionalities");
    final fileName = '$tourName.kml';

    final kmlFile = await _fileService.createFile(fileName, tourKml);

    await _sshData.uploadKml(kmlFile, fileName);

    await _sshData
        .execute('echo "\n$_url/$fileName" >> /var/www/html/kmls.txt');
    // await _sshData.execute(
    //     'chmod 777 /var/www/html/kmls.txt && echo "\n$_url/$fileName" >> /var/www/html/kmls.txt');
  }

  /// Sets the logos KML into the Liquid Galaxy rig. A KML [name] and [content] may be passed, but it's not required.
  Future<void> setLogos({
    String name = 'HAPIS-logos',
    String content = '<name>Logos</name>',
  }) async {
    print("inside set logos fun");
    final screenOverlay = ScreenOverlayModel.logos();

    final kml = KMLModel(
      name: name,
      content: content,
      screenOverlay: screenOverlay.tag,
    );

    try {
      await sendKMLToSlave(logoScreen, kml.body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Sends a KML [content] to the given slave [screen].
  Future<void> sendKMLToSlave(int screen, String content) async {
    // await clearKml();
    try {
      await _sshData
          .execute("echo '$content' > /var/www/html/kml/slave_$screen.kml");
      // await _sshData.execute(
      //     "chmod 777 /var/www/html/kml/slave_$screen.kml && echo '$content' > /var/www/html/kml/slave_$screen.kml");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Sends a the given [kml] to the Liquid Galaxy system.
  ///
  /// It also accepts a [List] of images represents by [Map]s. The [images] must
  /// have the following pattern:
  /// ```
  /// [
  ///   {
  ///     'name': 'img-1.png',
  ///     'path': 'path/to/img-1'
  ///   },
  ///   {
  ///     'name': 'img-2.png',
  ///     'path': 'path/to/img-2'
  ///   }
  /// ]
  /// ```
  Future<void> sendKml(KMLModel kml,
      {List<Map<String, String>> images = const []}) async {
    final fileName = '${kml.name}.kml';

    await clearKml();

    for (var img in images) {
      final image = await _fileService.createImage(img['name']!, img['path']!);
      String imageName = img['name']!;
      await _sshData.uploadKml(image, imageName);
    }

    final kmlFile = await _fileService.createFile(fileName, kml.body);
    await _sshData.uploadKml(kmlFile, fileName);

    await _sshData.execute('echo "$_url/$fileName" > /var/www/html/kmls.txt');
    // await _sshData.execute(
    //     'chmod 777 /var/www/html/kmls.txt && echo "$_url/$fileName" > /var/www/html/kmls.txt');
  }

  /// Clears all `KMLs` from the Google Earth. The [keepLogos] keeps the logos
  /// after clearing (default to `true`).
  // Future<void> clearKml({bool keepLogos = true}) async {
  //   print("inside clear kml fn");

  //   String query =
  //       'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

  //   //String query = "echo ' ' > /var/www/html/kmls.txt";

  //   // String query =
  //   //     'chmod 777 /tmp/query.txt && chmod 777 /var/www/html/kmls.txt && echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

  //   print("here");
  //   for (var i = 2; i <= screenAmount; i++) {
  //     String blankKml = KMLModel.generateBlank('slave_$i');
  //     query += "echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
  //   }

  //   print("after for in clear kml fn");
  //   print(query);

  //   print("keep logos: $keepLogos");

  //   if (keepLogos) {
  //     print("inside keep logos");
  //     final kml = KMLModel(
  //       name: 'HAPIS-logos',
  //       content: '<name>Logos</name>',
  //       screenOverlay: ScreenOverlayModel.logos().tag,
  //     );

  //     print("here");

  //     query += "echo '${kml.body}' > /var/www/html/kml/slave_$logoScreen.kml";
  //   }

  //   await _sshData.execute(query);
  //   print("finish clean kml");
  // }

  Future<void> clearKml({bool keepLogos = true}) async {
    print("inside clear kml fn");
    //print(_sshData.client.username);
    // if (await _sshData.client!.isConnected()) {
    //   print("check connection");
    // }

    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

    print("here");
    for (var i = 2; i <= screenAmount; i++) {
      String blankKml = KMLModel.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    if (keepLogos) {
      print("inside keep logos");
      final kml = KMLModel(
        name: 'SVT-logos',
        content: '<name>Logos</name>',
        screenOverlay: ScreenOverlayModel.logos().tag,
      );

      print("here");

      query +=
          " && echo '${kml.body}' > /var/www/html/kml/slave_$logoScreen.kml";
    }

    await _sshData.execute(query);
  }
}

/*
In this file, we would add all LG functionalities we might need including the following:
 1. connecting with LG  done
 2. shutting down LG   done
 3. Rebooting LG      done
 4. Relaunch the LG   done   --not working
 
 5. Fly to functionality   done
 6. orbit functionality

 7. determing logo screen (top left screen for the slaves)   done
 8. determing bubble screen (right screen for the slaves)    done
 9. set logos   done
 
 10. send KML to the LG system    
 11. clearing KML files          done
 12. send KML to slave           done

 13. set refresh
 14. reset refresh 
*/
