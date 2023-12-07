import 'package:bibliz/shared/build_app_bar.dart';
import 'package:flutter/material.dart';

class BookManagementPage extends StatefulWidget {
  const BookManagementPage({super.key});

  @override
  State<BookManagementPage> createState() => _BookManagementPageState();
}

class _BookManagementPageState extends State<BookManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Text("Book management"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _navigateAndAddNewBook();
        },
        tooltip: 'Ajouter un livre',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateAndAddNewBook() async {
    await Navigator.pushNamed(context, '/create_book');
  }
}
