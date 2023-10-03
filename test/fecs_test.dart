
import 'package:fecs/src/external/fecs_data_firebase.dart';
import 'package:fecs/src/infra/fecs_data.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FecsData cloudService = FecsDataFirebase();
  final user = { 'email': 'jhon@email.com', 'password': '123456' };
  final data = await cloudService.signupWithEmail(user);
  debugPrint(data.toString());
}
