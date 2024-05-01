 ## Fecs

Fecs - Flutter External Cloud Service: Flutter Package to work with external cloud services.

| **Support** | Android | iOS | Linux | macOS | Web | Windows |
|-------------|---------|------|-------|--------|-----|-------------|


## Features

interfaces:
- fecs_data

implementation:
- firabase


## Getting started

1. To use this package, add inani as dependency in your `pubspec.yaml` file:

```yaml
dependencies:
   fecs:
```


2. Import the package into your dart file:

```dart
import 'package:fecs/fecs.dart';
```


3. Add this depedencies to : /android/app/build.gradle

```java
plugins {
    ...
    
    id 'com.google.gms.google-services'
}

...

dependencies {
  ...

    // Import the BoM for the Firebase platform
    implementation platform('com.google.firebase:firebase-bom:32.8.0')
    implementation 'com.google.firebase:firebase-analytics'

    // Add the dependency for the Firebase Authentication library
    // When using the BoM, you don't specify versions in Firebase library dependencies
    implementation 'com.google.firebase:firebase-auth'

    // Also add the dependency for the Google Play services library and specify its version
    implementation 'com.google.android.gms:play-services-auth:21.0.0'
}
```

4. Add this depedencies to : /android/build.gradle

```java
buildscript {
    ...
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        ...
        classpath "com.google.gms:google-services:4.3.15"
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```


4. Add this depedencies to : /android/settings.gradle

```java
pluginManagement {
  ...

  repositories {
    google()
    mavenCentral()
    gradlePluginPortal()
  }

  ...
}
plugins {
    ...
    // START: FlutterFire Configuration
    id "com.google.gms.google-services" version "4.3.15" apply false
    // END: FlutterFire Configuration
}
```


## Usage

```dart
  WidgetsFlutterBinding.ensureInitialized();
  FecsData cloudService = FecsDataFirebase();
  final user = { 'email': 'jhon@email.com', 'password': '123456' };
  final data = await cloudService.signupWithEmail(user);
  debugPrint(data.toString());

```


## Additional information

For any bugs, issues and more information, please contact the package authors on email: gvgabrielvieiragabrielvieira@gmail.com.
