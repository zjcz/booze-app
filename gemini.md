### Project Overview

This project is a Flutter application called "booze_app". It is a mobile app for browsing and managing a collection of beers. The app uses Firebase for backend services, including authentication, database, and storage.

### General

Rules:
- Use the Dart programming language.
- Use the Flutter framework.
- The `pubspec.yaml` file indicates the following SDK constraint: `sdk: ^3.8.1`. Adhere to this version.
- When creating a new method, provide a doc comment (///) to document the method and arguments.

### Dependencies

The following dependencies are used in this project. Please use them as specified in the `pubspec.yaml` file.

- `flutter`
- `firebase_core: ^3.14.0`
- `firebase_auth: ^5.6.0`
- `cloud_firestore: ^5.6.9`
- `firebase_storage: ^12.4.7`
- `firebase_analytics: ^11.5.0`
- `image_picker: ^1.1.2`
- `cupertino_icons: ^1.0.8`
- `shared_preferences: ^2.5.3`
- `url_launcher: ^6.3.1`
- `flutter_markdown: ^0.7.7`
- `package_info_plus: ^8.3.0`

**Development Dependencies:**

- `flutter_test`
- `flutter_lints: ^5.0.0`

### UI

Rules:
- Make any UI you generate beautiful and user-friendly.

### Tests

Rules:
- Write unit tests for any code you generate.
- Write integration tests for any code you generate.
- If mocks are required, use the mockito library.
- Tests should be generated in the /test directory.
- Use the test directory structure to mirror the lib directory structure.
- When writing tests to get, list or delete a record, write additional tests to check that the records not found are handled correctly.
- When writing tests to check that a record is created, updated or deleted, test all the fields of a record that have been updated or set in the test contain the expected values.
- Use "[method name] should [expected behaviour] when [condition]" for the test description.
- Use the test name to describe the test case. For example, "GetUserById Should return User When user exists" instead of "testGetUserById".
- Use the AAA pattern for test cases. Arrange, Act, Assert. Use comments to separate the sections of the test.