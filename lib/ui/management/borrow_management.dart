import 'package:bibliz/database/borrows/borrow.dart';
import 'package:bibliz/database/borrows/borrows_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/ui/widget/search_bar_widget.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BorrowManagementPage extends StatefulWidget {
  const BorrowManagementPage({super.key});

  @override
  State<BorrowManagementPage> createState() => _BorrowManagementPageState();
}

class _BorrowManagementPageState extends State<BorrowManagementPage> {
  List<Borrow> borrows = [];
  List<Borrow> filteredBorrows = [];
  bool isBorrowsLoaded = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBorrows();
  }

  void _filterBorrows(String searchText) {
    setState(() {
      filteredBorrows = borrows.where((borrow) {
        final searchLower = searchText.toLowerCase();
        return borrow.bookTitle.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Libérer le contrôleur de texte
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
                                  "Bouton de rendu",
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
    );
  }

  Future<void> _loadBorrows() async {
    if (!isBorrowsLoaded) {
      try {
        List<Borrow> loadedBorrows = await BorrowsQuery().getBorrowsByUser(SharedPrefs().getCurrentUser()!);
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
          key: key, // Ajout de la clé unique au widget Row
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  onPressed: borrow.state.toLowerCase() == 'accepted'
                      ? () async {
                          await BorrowsQuery().returnBook(borrow);
                          isBorrowsLoaded = false;
                          _loadBorrows();
                        }
                      : null,
                  child: Text(
                    'Rendre',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
