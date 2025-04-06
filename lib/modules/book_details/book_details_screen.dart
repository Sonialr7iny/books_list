import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practicing_app/main.dart';
import 'package:practicing_app/modules/favorites/favorites_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../models/book_model/book_models.dart';
import '../../models/books/book_model.dart';
// import '../../models/book_model/book_models.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  // const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Check and set the initial value of isFavorite
  }

  Future<void> _checkIfFavorite() async {
    List<String> favoriteBooks = await getFavoriteBooks();
    setState(() {
      isFavorite = favoriteBooks.contains(widget.book.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeGridviewScreen()));
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios_rounded),
          iconSize: 20.0,
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigatorKey.currentState?.push(MaterialPageRoute(
                  builder: (context) => FavoritesScreen(allBooks: books)));
            },
            icon: Icon(Icons.favorite_outlined),
            color: Colors.black,
            iconSize: 20.0,
          ),
        ],
      ),
      body:Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: Alignment(0, 0),
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          // gradient: LinearGradient(colors: List.generate(2, (index) => Colors.white60,),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6.0,
                              offset: Offset(2, 2),
                              // spreadRadius: 2.2,
                            ),
                          ],
                        ),
                        // child: widget.book.bookImage
                      ),
                      Container(
                          width: 200.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child:
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(12),
                              //   child: widget.book.bookImage,
                              // ),

                              Hero(
                            tag: 'book_${widget.book.id}',
                                transitionOnUserGestures: true,
                            child: Image.asset(widget.book.imagePath)
                          ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    // Toggle favorite in SharedPreferences
                    await toggleFavorite(widget.book.id.toString());

                    // Update UI by fetching the latest favorite state
                    List<String> favoriteBooks = await getFavoriteBooks();
                    setState(() {
                      isFavorite = favoriteBooks.contains(
                          widget.book.id.toString()); // Update isFavorite
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // dismissDirection: DismissDirection.startToEnd,
                          content: isFavorite
                              ? Text('Add to favorites is done ')
                              : Text('Remove from favorites is done '),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            gapPadding: 30.0,
                          ),
                          behavior: SnackBarBehavior.floating,
                          // onVisible: () => Alignment.topLeft,
                        ),
                      );
                    });
                  },
                  icon: isFavorite
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_outline),
                ),
                Text(
                  widget.book.description,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.values.first,
                ),
              ],
            ),
          ),

        )
      ),
    );
  }

  Future<void> toggleFavorite(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteBooks = prefs.getStringList('favorites') ?? [];

    if (favoriteBooks.contains(bookId)) {
      favoriteBooks.remove(bookId); // Remove if already a favorite
    } else {
      favoriteBooks.add(bookId); // Add if not already a favorite
    }

    await prefs.setStringList('favorites', favoriteBooks); // Save updated list
    if (kDebugMode) {
      print('Favorite Books in SharedPreferences: $favoriteBooks');
    }
  }

  Future<List<String>> getFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];

  }
}

