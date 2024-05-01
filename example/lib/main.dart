import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fecs/fecs.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: 'tchissola-1c2d0',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fecs Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'User: '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String image = 'https://picsum.photos/200';
  String _userData = 'no login';

  Future<void> _registerUser(String id) async {
    FecsData cloudService = FecsDataFirebase();
    final user = {
      'email': 'gabriel$id@email.com',
      'password': '123456',
      'nome': 'Gabriel$id',
    };
    final data = await cloudService.signupWithEmail(user);
    setState(() {
      _userData = ('register: $data');
    });
  }

  Future<void> _registerLogin(String id) async {
    FecsData cloudService = FecsDataFirebase();
    //final user = {'email': 'gabriel@email.com', 'password': '123456'};
    final data = await cloudService.loginWithEmail(
      email: 'gabriel$id@email.com',
      password: '123456',
    );
    setState(() {
      _userData = ('login: $data');
    });
  }

  Future<void> _logout() async {
    FecsData cloudService = FecsDataFirebase();
    //final user = {'email': 'gabriel@email.com', 'password': '123456'};
    await cloudService.logout();
    setState(() {
      image = 'https://picsum.photos/200';
      _userData = 'no login';
    });
  }

  Future<void> _signInWithGoogle() async {
    FecsData cloudService = FecsDataFirebase();
    final data = await cloudService.signupWithEmailGoogle();
    setState(() {
      _userData = ('login: $data');
      image = data['picture'];
    });
  }

  late String id;

  // generate ramdom number
  String getRandomNumber() {
    var random = Random();
    return random.nextInt(1000).toString();
  }

  @override
  void initState() {
    super.initState();
    id = getRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title + id),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, width: 200),
              const SizedBox(height: 20),
              Text(
                _userData,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _registerUser(id),
                    child: const Text('Register'),
                  ),
                  ElevatedButton(
                    onPressed: () => _registerLogin(id),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () => _registerLogin(id),
                    child: const Text('Logout'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _signInWithGoogle(),
                child: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
