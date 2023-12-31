import 'package:bibliz/database/borrows/borrow.dart';
import 'package:bibliz/database/borrows/borrows_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/ui/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookManagementPage extends StatefulWidget {
  const BookManagementPage({super.key});

  @override
  State<BookManagementPage> createState() => _BookManagementPageState();
}

class _BookManagementPageState extends State<BookManagementPage> {
  List<Borrow> borrows = [];
  List<Borrow> filteredBorrows = [];
  bool isBorrowsLoaded = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBorrows();
  }
  /*
    Fonction permettant de mettre a jour la liste des emprunts a chaque modification dans la barre de recherche.
  */
  void _filterBorrows(String searchText) {
    setState(() {
      filteredBorrows = borrows.where((borrow) {
        final searchLower = searchText.toLowerCase();
        return borrow.borrower.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SearchBarWidget(
                              hintText: "Rechercher un emprunt",
                              searchController: _searchController,
                              onSearchChanged: _filterBorrows),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Emprunteur",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Titre du livre",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Text(
                                    "ISBN du livre",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 150,
                                child: Text(
                                  "Status",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 150,
                                child: Text(
                                  "Date de demande/rendu",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 150,
                                child: Text(
                                  "Bouton d'acceptation/rejet",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: filteredBorrows.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildRowTemplate(
                                filteredBorrows[index], Key(index.toString()));
                          }),
                    ),
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          await _navigateAndAddNewBook();
        },
        tooltip: 'Ajouter un livre',
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  /*
    Fonction permettant de charger la liste des emprunts et de la mettre à jour avec les données de la base de données.
  */
  Future<void> _loadBorrows() async {
    if (!isBorrowsLoaded) {
      try {
        List<Borrow> loadedBorrows = await BorrowsQuery().getBorrows();
        setState(() {
          borrows = loadedBorrows;
          filteredBorrows = loadedBorrows;
          isBorrowsLoaded = true;
        });
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  /*
    Fonction permettant de générer une ligne avec les détails pour chaque emprunts
  */
  Widget buildRowTemplate(Borrow borrow, Key key) {
    String date;
    String state;

    if (borrow.returnDate != null) {
      date = DateFormat('dd/MM/yyyy HH:mm').format(borrow.returnDate!);
    } else {
      date = DateFormat('dd/MM/yyyy HH:mm').format(borrow.requestDate);
    }

    if (borrow.state == "request") {
      state = "Demande d'emprunt";
    } else if (borrow.state == "rejected") {
      state = "Demande rejetée";
    } else if (borrow.state == "accepted") {
      state = "Demande acceptée";
    } else {
      state = "Livre rendu";
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          key: key,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 150,
                  child: Text(
                    borrow.borrower,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 150,
                  child: Text(
                    borrow.bookTitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 150,
                  child: Text(
                    borrow.bookIsbn,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: Text(
                  state,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: Text(
                  date,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: borrow.state.toLowerCase() == 'request'
                        ? () async {
                            await BorrowsQuery()
                                .acceptBorrowRequest(borrow)
                                .catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                            isBorrowsLoaded = false;
                            _loadBorrows();
                          }
                        : null,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Icon(Icons.check),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: borrow.state.toLowerCase() == 'request'
                        ? () async {
                            await BorrowsQuery()
                                .rejectBorrowRequest(borrow)
                                .catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                            isBorrowsLoaded = false;
                            _loadBorrows();
                          }
                        : null,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAndAddNewBook() async {
    await Navigator.pushNamed(context, '/create_book');
  }
}
