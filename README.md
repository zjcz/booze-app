# Booze App

A flutter application to track the beers you like, the ones you want to try, and the ones you have already tasted. The app is built using Flutter and Firebase.

## 🖥️ Instructions

To run the app you will need to install flutter. Follow this [Get Started](https://docs.flutter.dev/get-started/install) guide.

- Create a project in Firebase

  - Go to the [Firebase console](https://console.firebase.google.com/).
  - Click on "Add project" and give your project a name (e.g., "Booze-app").
  - Follow the on-screen instructions to create the project. The app requires Analytics.

- The app uses Firebase Authentication to sign in users. We currently use Email + password but could expand it later to include other providers like Google, Facebook, etc.

  - In the Firebase project console, go to the Authentication section.
  - Click on the "Get Started" button.
  - Enable the "Email/Password" provider.

- Clone the repository

```bash
git clone https://github.com/zjcz/booze-app.git
```

- Navigate to the project directory

```bash
cd booze_app
```

- If you don't have the FlutterFire CLI installed, run this command to add it:

```bash
dart pub global activate flutterfire_cli
```

- Run the following command to configure Firebase for your Flutter app. This command will guide you through selecting your Firebase project and will automatically generate the firebase config files for you platforms:

```bash
flutterfire configure
```

- Install the remaining dependencies

```bash
flutter pub get
```

- Start the emulator or connect a device
- Run the application

```bash
flutter run
```
