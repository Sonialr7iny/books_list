import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/books/book_model.dart';

class FavoritesScreen extends StatefulWidget {
  final List<BookModel> allBooks;

  const FavoritesScreen({super.key, required this.allBooks});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
 // Pass all books to filter favorites
  Future<List<BookModel>> getFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteBookIds = prefs.getStringList('favorites') ?? [];
    print('All Books Passed to FavoritesScreen: ${widget.allBooks.map((book) => book.id).toList()}');
    print('Favorite Book IDs from SharedPreferences: $favoriteBookIds');
    // Filter allBooks to include only the ones marked as favorites
    return widget.allBooks.where((book) => favoriteBookIds.contains(book.id.toString())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Books"),
      ),
      body: FutureBuilder<List<BookModel>>(
        future: getFavoriteBooks(), // Get the favorite books
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading spinner
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            print('Filtered Favorite Books: ${snapshot.data!.map((book) => book.name).toList()}');
            // print('All Books in FavoritesScreen: ${widget.allBooks.length}');
            // print('Filtered Favorite Books: ${snapshot.data!.length}');
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  title: Text(book.name),
                  subtitle: Text(book.author),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: book.bookImage, // Show book image
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No favorite books yet.")); // No favorites
          }
        },
      ),
    );
  }
}
