import 'package:bibliz/ui/account/signup.dart';
import 'package:flutter/material.dart';

import '../../database/books/book.dart';
import '../../database/books/books_query.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final BookQuery bookQuery = BookQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Ajoutez ici la logique de vérification du login
                String email = _emailController.text;
                String password = _passwordController.text;
                print('Email: $email\nPassword: $password');
              },
              child: const Text('Connexion'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpPage()));
              },
              child: const Text("S'inscrire"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Création d'un livre en dur pour tester
                Book book = Book(
                    title: "Exemple de Titre",
                    author: "Exemple d'Auteur",
                    isbn: "1234567890",
                    publisher: "Exemple d'Éditeur",
                    publicationYear: 2023,
                    genre: "Fiction",
                    summary: "Ceci est un résumé d'exemple.",
                    language: "Français",
                    status: "Disponible",
                    condition: "Neuf",
                    location: "Rayon 1");

                bookQuery.addBook(book);
              },
              child: const Text("Créer un Livre de Test"),
            ),
            ElevatedButton(
              onPressed: () async {
                String titleToSearch =
                    "Exemple de Titre"; // Remplacez par le titre à rechercher
                Book? book = await bookQuery.getBookByTitle(titleToSearch);

                if (book != null) {
                  print("Livre trouvé: ${book.title}");
                  // Vous pouvez aussi afficher les détails du livre ici ou sur une nouvelle page
                } else {
                  print("Aucun livre trouvé avec ce titre");
                }
              },
              child: const Text("Rechercher un Livre par Titre"),
            ),
          ],
        ),
      ),
    );
  }
}
