import 'package:bibliz/firebase_options.dart';
import 'package:bibliz/ui/account/signin.dart';
import 'package:bibliz/ui/account/signup.dart';
import 'package:bibliz/ui/create_book_page.dart';
import 'package:bibliz/ui/home.dart';
import 'package:bibliz/ui/management/administration.dart';
import 'package:bibliz/ui/management/book_management.dart';
import 'package:bibliz/ui/management/borrow_management.dart';
import 'package:bibliz/ui/management/edit_profil.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefs().initSharedPrefs();
  String? currentUser = SharedPrefs().getCurrentUser();

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 8, 50, 70),
            primary: const Color.fromARGB(255, 8, 50, 70),
            secondary: const Color.fromARGB(255, 246, 221, 207)),
        useMaterial3: true,
      ),
      home: MainPage(currentUser: currentUser),
      routes: {
        '/home': (context) => const HomePage(),
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => const SignUpPage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/administration': (context) => const AdministrationPage(),
        '/book_management': (context) => const BookManagementPage(),
        '/borrows': (context) => const BorrowManagementPage(),
        '/create_book': (context) => const CreateBookPage(),
      },
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
