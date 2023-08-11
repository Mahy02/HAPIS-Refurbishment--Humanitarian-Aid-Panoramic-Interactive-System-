# HAPIS “Humanitarian Aid Panoramic Interactive system”

## Welcome to HAPIS project

This project was started as Google Summer of Code 2020 project by my mentor Claudia Diosan as “Homeless Aid Panoramic Interactive system” but due to Covid-19 the launch lagged behind. It was decided that it needs refurbishment and the project refurbishment has started as Google Summer Of Code 2023 project.

It is an Android application that aims to connect people all over the world together to allow people who want to donate something to help those who need or seek something. Things donated can fall into many categories such as Food, Clothes, Toys & games, Books & Media, Electronics, Pet food, Baby items, Housing items….etc. Besides, it can be connected with the Liquid Galaxy System to view all global and local statistics for each city as well as show users information for each city, donors and seekers. 



## Google Summer Of Code 2023 with Liquid Galaxy Organization:

<div style="display: flex; justify-content: center;">
  <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week1/hapis/assets/images/LOGO%20LIQUID%20GALAXY-sq1000-%20OKnoline.png" alt="Liquid Galaxy logo" width="200" style="margin-right: 20px;">
  <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week1/hapis/assets/images/gsoc.png" alt="GsoC logo" width="260">
</div>


## App screenshots

### Main application part


### Liquid Galaxy Part




## Prerequisites & Usage For running the APK

### For the main application:

**Prerequisites:** 

* Need to have an Android Phone or Tablet with a minimum android version “Android 11”

* _Step 1: Download the apk_

You can find the apk here: #link  or From the PlayStore: #link

* _Step 2: Install_

Follow the instructions for installation on your Android device

* _Step 3: Start using the app !!_



Once you open the app, you can see all users either seekers or donors and all their personal information and what they seek/donate

#screenshot of home page

You cannot request a donation or fill a new form unless you login or signup first, otherwise you will get the following error:

#screenshot of signin error

You can signup from here:

#screenshot of signup/login

once you sign up, you can fill a donor form or a seeker form

#screenshot of both forms

Or you can request any user you want

#request screenshot

You can also find all requests from here

#screenshot of requests

Or Matchings that the app itself matched for you

#screenshot of matches

Once you finish a donation process, you can end the donation from here:

#end donation screenshot

Now the donation is sucessful :)

#success donation

You can delete your account anytime you want by opening the side menu, choosing settings, then delete account from here:

#side bar and delete settings


### For the Liquid Galaxy part:

**Prerequisites:**

* Need to have an Android Phone or Tablet
* In case you want to use the application with Liquid Galaxy System, refer to: https://github.com/LiquidGalaxyLAB/liquid-galaxy for setting up the virtual machines and installing the liquid galaxy rig on the machines

* _Step 1: Download the apk_
You can find the apk here: #link  or From the PlayStore: #link

* _Step 2: Install_
Follow the instructions for installation on your Android device

* _Step 3: Connect to Liquid Galaxy_
  
Switch to the Liquid Galaxy part by clicking on the icon above in the app bar:

#icon switch

If you are not connected to the LG, you will probably not be able to click on any of the buttons, and you will face the following error:
#lg connection error

So to connect you can go to the side menu bar and choose Connect to LG
Fill out with the LG username and password, the LG IP address and the port number is always 22. Identify the number Of LG screens which you will use. 
If you saw “Connected” then congratulations, you now can visualise anything on your LG :) 

#Screenshot of “Connected” 

Otherwise, you would find an error message that shows you exactly what went wrong with the connection

For example if you entered an incorrect username or password you will get the following error:

#pass connection error

Else if you entered wrong IP address, port or you haven't set up your LG Rig you will get the following error:

#other error

* _Step 4: Visualising on LG_

This is the home page where you can click on Global statistics to fly to the Globe starting point and show the Global Statistics Balloon on the LG Slave (right most)

#screenshot of home page
#screenshot of the machines with global statistics 

You can also click on the cities button to navigate to see all cities in the app

#screenshot of cities page

When you choose a city, the LG flies to the city and shows the local statistics balloon of the city. The app also navigates to the page where you can see all users locations pins on the LG or choose to see donors and seekers of this city.

#screenshot of donors/seekers page 
#screenshot of LG local stats

If you clicked on the button "Show users pins" you will be able to see the donors and seekers pins on the map

#screenshot of pins


When you choose donors or seekers, the app will navigate to the page where it will show all users available for this city either seekers or donors, you can click on the info button to show users balloon with all the users info and transactions. It will also take you to the user's location.

#screenshot of user location + balloon 
#screenshot of users pages

You can also orbit around the user's location or stop the orbit whenever you need

#screenshot of orbit

You can also clear the KML, shutdown, reboot or relaunch the LGs from the settings page of the LG part

#screenshot of settings

### Prerequisites & Usage For running the code from the source

**Prerequisites:**

- Visual Studio Code or Android Studio or another IDE that supports flutter development
- Flutter SDK
- Android SDK
- Android device or emulator
- Git
  
> Documentation on how to set up flutter SDK and its environment can be found here:  https://flutter.dev/docs/get-started/install


* _Step 1: Clone the Repository_

The full code is located in this GitHub repository. To clone the project via terminal use the command:

```bash
git clone https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-.git 
```

* _Step 2: Run the code_

Open a terminal and navigate to the project root directory. First you need to install all the packages by running the following command:
```bash
flutter pub get
```

After successfully installing the packages, make sure you have a device connected, either a real android phone or an emulator. You can run flutter doctor to check out the connected devices and if all environment is correct
```bash
flutter doctor
```

Since dart is moving up versions to offer null safety, some packages that are being used still haven’t migrated to the new null safety policies, so we need to run the project with the following command
```bash
flutter run --no-sound-null-safety
```

If you followed all the steps till now you have your app up and running.

Enjoy HAPIS  :)  !!









