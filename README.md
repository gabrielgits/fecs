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

2. To use this package, add inani as dependency in your `pubspec.yaml` file:

```yaml
dependencies:
   fecs:
```

3. Import the package into your dart file:

```dart
import 'package:fecs/fecs.dart';
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
