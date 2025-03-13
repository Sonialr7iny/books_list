import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practicing_app/main.dart';
import 'package:practicing_app/modules/book_details/book_details_screen.dart';
// import 'package:practicing_app/main.dart';
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
    if (kDebugMode) {
      print('All Books Passed to FavoritesScreen: ${widget.allBooks.map((book) => book.id).toList()}');
    }
    if (kDebugMode) {
      print('Favorite Book IDs from SharedPreferences: $favoriteBookIds');
    }
    // Filter allBooks to include only the ones marked as favorites
    return widget.allBooks.where((book) => favoriteBookIds.contains(book.id.toString())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Books",),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 20.0,)),
      ),
      body: FutureBuilder<List<BookModel>>(
        future: getFavoriteBooks(), // Get the favorite books
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading spinner
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (kDebugMode) {
              print('Filtered Favorite Books: ${snapshot.data!.map((book) => book.name).toList()}');
            }
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
                    child:Image.asset(book.imagePath) // Show book image
                  ),
                  onTap: (){
                    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context)=>BookDetailsScreen(book: book)));
                  },
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
