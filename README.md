# 🍻 Booze App

A flutter application to track the beers you like, the ones you want to try, and the ones you have already tasted. The app is built using Flutter and Firebase.

## 🖥️ Instructions

The app is written in Flutter and uses Firebase for cloud services.

### Firebase Configuration

To configure the [Firebase](https://firebase.google.com/?authuser=0) services used by this application, follow these steps:

- Create a project in Firebase

  - Go to the [Firebase console](https://console.firebase.google.com/).
  - Click on "Create a Firebased project" and give your project a name (e.g., "Booze-app").
  - Follow the on-screen instructions to create the project. The app requires Analytics.

- The app uses Firebase Authentication to sign in users. We currently use Email + password but could expand it later to include other providers like Google, Facebook, etc.

  - In the Firebase project console, go to the "Authentication" section.
  - Click on the "Get Started" button.
  - Enable the "Email/Password" provider.

- The app uses Firebase Storage to store images of the beers we add.

  - In the Firebase project console, go to the "Storage" section.
  - Firebase Storage requires billing to be enabled on your account. If you don't have billing enabled click "Upgrade project". This will guide you through the steps of adding billing to your account and setting up budget alerts.
  - Click "Get started" to setup your storage bucket. Follow the onscreen prompts
  - To allow the app to upload and read images from the bucket, set the following rule:

```
  service firebase.storage {
    match /b/{bucket}/o {
      match /beer_images/{userId}/{fileName} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
```

- The app uses Firestore Database to store the data.

  - In the Firebase project console, go to the "Firestore Database" section.
  - Click "Create database" to setup your database. Follow the onscreen prompts

```
  service cloud.firestore {
    match /databases/{database}/documents {
      // Allow only authenticated content owners access
      match /users/{userId}/beers/{document} {
        allow read, write: if request.auth != null && request.auth.uid == userId
      }
    }
  }
```

### Code

To run the app you will need to install flutter. Follow this [Get Started](https://docs.flutter.dev/get-started/install) guide.

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

## Terms and Conditions, Privacy Policy

Placeholder Terms and Conditions and the Privacy Policy pages have been added to the app for production readiness.  Once the app is finalised these can be generated at [App Privacy Policy Generator](https://app-privacy-policy-generator.firebaseapp.com/)