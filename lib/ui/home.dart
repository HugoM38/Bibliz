import 'package:bibliz/database/books/book_detail_modal.dart';
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
  int crossAxisCount = 6;
  int booksCount = 100;

  @override
  void initState() {
    super.initState();
    _loadBooks(booksCount);
  }

  Future<void> _loadBooks(int count) async {
    try {
      List<Book> loadedBooks = await BookQuery().getBooks(count);
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          crossAxisCount, // Nombre d'éléments par ligne
                      childAspectRatio: 0.7, // Ratio de l'aspect des éléments
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4.0, // Ajoute une légère ombre
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BookDetailModal(book: books[index]);
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          books[index].imageUrl ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  books[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  books[index].author,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton<int>(
              value: crossAxisCount,
              onChanged: (int? newValue) {
                setState(() {
                  crossAxisCount = newValue!;
                });
              },
              items: <int>[6, 7, 8].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value éléments par ligne'),
                );
              }).toList(),
            ),
            DropdownButton<int>(
              value: booksCount,
              onChanged: (int? newValue) {
                setState(() {
                  booksCount = newValue!;
                  _loadBooks(booksCount);
                });
              },
              items: <int>[50, 100, 150, 200]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Charger $value livres'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
