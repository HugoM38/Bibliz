import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/ui/management/administration.dart';
import 'package:bibliz/ui/management/book_management.dart';
import 'package:bibliz/ui/management/edit_profil.dart';
import 'package:bibliz/database/books/book.dart'; // Assurez-vous que ce chemin est correct
import 'package:bibliz/database/books/books_query.dart'; // Assurez-vous que ce chemin est correct
import 'package:flutter/material.dart';
import 'package:bibliz/ui/create_book_page.dart';
import 'package:bibliz/ui/account/signin.dart';
import 'package:bibliz/utils/sharedprefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      List<Book> loadedBooks = await BookQuery().getBooks(100);
      setState(() {
        books = loadedBooks;
      });
    } catch (e) {
      print('Erreur lors du chargement des livres: $e');
    }
  }

  Widget _getManagementButton() {
    Widget widget;
    switch (SharedPrefs().getCurrentUserRole()) {
      case UserRole.member:
        widget = ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()));
            },
            child: const Text("Gestion du profil"));
        break;
      case UserRole.librarian:
        widget = ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookManagementPage()));
            },
            child: const Text("Gestion des livres"));
        break;
      case UserRole.administrator:
        widget = ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdministrationPage()));
            },
            child: const Text("Administration"));
        break;
      default:
        widget = ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()));
            },
            child: const Text("Modifier mon profil"));
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bibliz"),
        actions: [
          ElevatedButton(
              onPressed: () async {
                await SharedPrefs().removeCurrentUser();

                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigninPage()));
                }
              },
              child: const Text("Se déconnecter")),
          _getManagementButton()
        ],
      ),
      body: books.isEmpty
          ? const Center(child: Text('Aucun livre disponible.'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: books[index].imageUrl != null
                        ? Image.network(books[index].imageUrl!,
                            fit: BoxFit.cover)
                        : const SizedBox
                            .shrink(), // Pas d'image si imageUrl est null
                    title: Text(books[index].title),
                    subtitle: Text(books[index].summary),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBookPage()),
          );
        },
        tooltip: 'Ajouter un livre',
        child: const Icon(Icons.add),
      ),
    );
  }
}
