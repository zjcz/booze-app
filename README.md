# 🍻 Booze App

![test status](https://github.com/zjcz/booze-app/actions/workflows/tests.yml/badge.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Flutter Version](https://img.shields.io/badge/Flutter-^3.32.2-blue.svg)](https://flutter.dev/)

![Booze App](/assets/images/icon-256x256.png?raw=true "Booze App")

A mobile application to track the beers you like. The app is built using Flutter and Firebase.

## ✨ Features

- Track your favorite beers
- Add ratings and notes
- Upload beer photos
- All data synced to the cloud with Firebase

## 🖥️ Setup Instructions

The app is written in Flutter and uses Firebase for cloud services.

### Firebase Configuration

To configure the [Firebase](https://firebase.google.com/?authuser=0) services used by this application, follow these steps:

- Create a project in Firebase

  - Go to the [Firebase console](https://console.firebase.google.com/).
  - Click on "Create a Firebased project" and give your project a name (e.g., "Booze-app").
  - Follow the on-screen instructions to create the project. The app currently does not use Analytics so this is optional.

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

## 📸 Screenshots

![home screen - list view mode](/screenshots/home-list-view.png?raw=true "Home Screen - List View Mode")
![home screen - grid view mode](/screenshots/home-grid-view.png?raw=true "Home Screen - Grid View Mode")
![details screen](/screenshots/details.png?raw=true "Details Screen")
![add screen](/screenshots/add.png?raw=true "Add Screen")
![edit screen](/screenshots/edit.png?raw=true "Edit Screen")
![about screen](/screenshots/about.png?raw=true "About Screen")

## 🚂 Motivation

This is an app I have been planning on writing for a while. I used a similar app a few years ago but it only stores data locally on the device (so I lost everything when my old phone died 😥) and unfortunately it is no longer maintained.

This is very much a personal project and I have no intention of releasing it to the app stores. Feel free to fork the repo and build the app yourself for your own use.

## 🪄 AI Coding Assistant

[Gemini Coding Partner Gem](https://gemini.google.com/gem/coding-partner), [Gemini CLI](https://github.com/google-gemini/gemini-cli) and [Gemini Code Assist](https://marketplace.visualstudio.com/items?itemName=Google.geminicodeassist) were all used in the building of this app.

The project contains a `gemini.md` instructions file and [Context7](https://github.com/upstash/context7) MCP server has been configured to assist Gemini.

## 🎨 Icons and Images

Icons and images were created by a human (no Gen AI model can generate images that look this bad!) in [Figma](https://www.figma.com/), loosely following the guide on [How to Design Your Flutter App Icons in Figma (for Beginners)](https://www.youtube.com/watch?v=yxg9yrZdDlw). Resizing done using [GIMP](https://www.gimp.org/). Images converted to icons for iOS using [App icon Generator](appicon.co). Icons added to Android using the [Configure Image Asset](https://developer.android.com/studio/write/create-app-icons) screen in Android Studio (apps -> res, right click, New -> Image Asset). Splash screen created using [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash).

## 📄 Terms and Conditions, Privacy Policy

Placeholder Terms and Conditions and the Privacy Policy pages have been added to the app for production readiness. Once the app is finalised these can be generated at [App Privacy Policy Generator](https://app-privacy-policy-generator.firebaseapp.com/)

## 💼 License

This project is licensed under the GNU General Public License v3.0 - see the [license.md](license.md) file for details.
