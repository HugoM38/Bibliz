import 'package:bibliz/database/books/book_detail_modal.dart';
import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/database/books/book.dart';
import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/ui/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:bibliz/utils/sharedprefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isBooksLoaded = false;
  int crossAxisCount = 6;
  int booksCount = 100;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks(booksCount);
  }

  void _filterBooks(String searchText) {
    setState(() {
      filteredBooks = books.where((book) {
        final searchLower = searchText.toLowerCase();
        return book.title.toLowerCase().contains(searchLower) ||
            book.author.toLowerCase().contains(searchLower) ||
            book.genre.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  Future<void> _loadBooks(int count) async {
    if (!isBooksLoaded) {
      try {
        List<Book> loadedBooks = await BookQuery().getBooks(count);
        setState(() {
          books = loadedBooks;
          filteredBooks = loadedBooks; // Initialisez également filteredBooks
          isBooksLoaded = true;
        });
      } catch (e) {
        print('Erreur lors du chargement des livres: $e');
      }
    }
  }

  Future<void> _navigateAndAddNewBook() async {
    final newBook = await Navigator.pushNamed(context, '/create_book');

    if (newBook is Book) {
      setState(() {
        books.add(newBook);
      });
    }
  }

  Widget _getManagementButton() {
    Widget widget;
    switch (SharedPrefs().getCurrentUserRole()) {
      case UserRole.member:
        widget = ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
            child: Text(
              "Gestion du profil",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ));
        break;
      case UserRole.librarian:
        widget = ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/book_management');
            },
            child: const Text("Gestion des livres"));
        break;
      case UserRole.administrator:
        widget = ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/administration');
            },
            child: Text(
              "Administration",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ));
        break;
      default:
        widget = ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profil');
            },
            child: Text(
              "Modifier mon profil",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ));
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Image.asset(
                'logo.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
          ],
        ),
        title: SearchBarWidget(
          searchController: searchController,
          onSearchChanged: _filterBooks,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () async {
                  await SharedPrefs().removeCurrentUser();

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/signin');
                  }
                },
                child: Text(
                  "Se déconnecter",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )),
          ),
          _getManagementButton()
        ],
      ),
      body: books.isEmpty
          ? Center(
              child: Text(
              'Aucun livre disponible.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[
                            index]; // Utilisez cette variable pour construire votre widget
                        return Card(
                          color: Theme.of(context).colorScheme.primary,
                          elevation: 4.0,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BookDetailModal(book: book);
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
                                        image: NetworkImage(book.imageUrl ??
                                            ''), // Utilisez 'book.imageUrl'
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    book.title,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    book.author,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndAddNewBook();
        },
        tooltip: 'Ajouter un livre',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton<int>(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              dropdownColor: Theme.of(context).colorScheme.secondary,
              value: crossAxisCount,
              elevation: 8,
              icon: Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.primary),
              underline: Container(
                  height: 2, color: Theme.of(context).colorScheme.primary),
              onChanged: (int? newValue) {
                setState(() {
                  crossAxisCount = newValue!;
                });
              },
              items: <int>[6, 7, 8].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '$value éléments par ligne',
                  ),
                );
              }).toList(),
            ),
            DropdownButton<int>(
              value: booksCount,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              dropdownColor: Theme.of(context).colorScheme.secondary,
              elevation: 8,
              icon: Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.primary),
              underline: Container(
                  height: 2, color: Theme.of(context).colorScheme.primary),
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
