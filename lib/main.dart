import 'package:bibliz/firebase_options.dart';
import 'package:bibliz/ui/account/signin.dart';
import 'package:bibliz/ui/home.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefs().initSharedPrefs();
  String? currentUser = await SharedPrefs().getCurrentUser();

  print("Logged as $currentUser");

  runApp(Bibliz(
    currentUser: currentUser,
  ));
}

class Bibliz extends StatelessWidget {
  const Bibliz({super.key, required this.currentUser});
  final String? currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bibliz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade600),
        useMaterial3: true,
      ),
      home: MainPage(currentUser: currentUser),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.currentUser});
  final String? currentUser;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            widget.currentUser != null ? const HomePage() : const SigninPage());
  }
}
