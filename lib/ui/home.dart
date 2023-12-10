import 'package:bibliz/ui/widget/book_detail_modal.dart';
import 'package:bibliz/database/books/book_manager.dart';
import 'package:bibliz/database/books/book.dart';
import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/ui/management_proxy/management_proxy.dart';
import 'package:bibliz/ui/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:bibliz/utils/sharedprefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> filteredBooks = [];
  List<String> searchOptions = ['Titre', 'Genre', 'Auteur'];
  int crossAxisCount = 6;
  int booksCount = 100;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController dropdownController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    dropdownController.text = 'Titre';
    _loadBooks(booksCount);
  }

  void _filterBooks(String searchText) {
    final searchLower = searchText.toLowerCase();
    final searchType = dropdownController.text;

    setState(() {
      filteredBooks = BookManager().books.where((book) {
        switch (searchType) {
          case 'Titre':
            return book.title.toLowerCase().contains(searchLower);
          case 'Auteur':
            return book.author.toLowerCase().contains(searchLower);
          case 'Genre':
            return book.genre.toLowerCase().contains(searchLower);
          default:
            return true;
        }
      }).toList();
    });
  }

  Future<void> _loadBooks(int count) async {
    if (!BookManager().isBooksLoaded) {
      try {
        List<Book> loadedBooks = await BooksQuery().getBooks(count);
        setState(() {
          BookManager().books = loadedBooks;
          BookManager().isBooksLoaded = true;
        });
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$error"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    setState(() {
      filteredBooks = BookManager().books;
    });
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
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: SearchBarWidget(
                hintText: "Rechercher un livre",
                searchController: searchController,
                onSearchChanged: _filterBooks,
                searchOptions: searchOptions,
                dropdownController: dropdownController,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () async {
                  await SharedPrefs().removeCurrentUser();

                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/signin',
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  "Se déconnecter",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )),
          ),
          ManagementProxy()
              .getManagementButton(context, _loadBooks, booksCount, "", ""),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () async {
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      '/borrows',
                    );
                  }
                },
                child: Text(
                  "Mes emprunts",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )),
          ),
        ],
      ),
      body: BookManager().books.isEmpty
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
                            index];
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
                                            ''),
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
