
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practicing_app/main.dart';
import 'package:practicing_app/modules/home_gridview/home_gridview_screen.dart';

import 'package:provider/provider.dart';

import '../../models/books/book_model.dart';
import '../../models/provider_/provider.dart';
import '../favorite_provider/favorites_provider_screen.dart';


class BookDetailsScreenProvider extends StatefulWidget {
  final bool isDarkMode; // Add this property
  final Function(bool) toggleTheme; // Add this property

  const BookDetailsScreenProvider({
    super.key,
    required this.isDarkMode, // Make it required
    required this.toggleTheme, // Make it required
  });


  // const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreenProvider> createState() =>
      _BookDetailsScreenProviderState();
}

class _BookDetailsScreenProviderState extends State<BookDetailsScreenProvider> {
  bool isFavorite = false;

  @override
  // void initState() {
  //   super.initState();
  //   _checkIfFavorite(); // Check and set the initial value of isFavorite
  // }
  //
  // Future<void> _checkIfFavorite() async {
  //   List<String> favoriteBooks = await getFavoriteBooks();
  //   setState(() {
  //     isFavorite = favoriteBooks.contains(widget.book.id.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    final book = ModalRoute.of(context)?.settings.arguments as BookModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeGridviewScreen()));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeGridviewScreen(
                  isDarkMode: widget.isDarkMode, // Access from widget
                  toggleTheme: widget.toggleTheme, // Access from widget
                ),
              ),
                  (route) => false,
            );


          },
          icon: Icon(Icons.arrow_back_ios_rounded),
          iconSize: 20.0,
          color: widget.isDarkMode?Colors.pink[30]:Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
            Navigator.pushNamed(context, '/favorites',arguments: book);
            },
            icon: Icon(Icons.favorite_outlined),
            color: widget.isDarkMode?Colors.pink[30]:Colors.black,
            iconSize: 20.0,
          ),
        ],
      ),
      body: Center(
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
                        tag: 'book_${book.id}',
                        transitionOnUserGestures: true,
                        child:Image.asset(book.imagePath),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  // Toggle favorite in SharedPreferences
                  //
                  booksProvider.toggleFavorite(book);
                  if (kDebugMode) {
                    print('Favorite Books in SharedPreferences: $booksProvider._favorite');
                  }
                  // Update isFavorite
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      // dismissDirection: DismissDirection.startToEnd,
                      content:
                      booksProvider.isFavorite(book)
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
                },
                icon:  Consumer<BooksProvider>(
                  builder: (context, provider, child) {
                    return Icon(
                      provider.isFavorite(book) ? Icons.favorite : Icons.favorite_border,
                    );
                  },

                )),
              Text(
                book.description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.values.first,
              ),
            ],
          ),
        ),
      )),
    );
  }

// Future<void> toggleFavorite(String bookId) async {
//   final prefs = await SharedPreferences.getInstance();
//   List<String> favoriteBooks = prefs.getStringList('favorites') ?? [];
//
//   if (favoriteBooks.contains(bookId)) {
//     favoriteBooks.remove(bookId); // Remove if already a favorite
//   } else {
//     favoriteBooks.add(bookId); // Add if not already a favorite
//   }
//
//   await prefs.setStringList('favorites', favoriteBooks); // Save updated list
//   if (kDebugMode) {
//     print('Favorite Books in SharedPreferences: $favoriteBooks');
//   }
// }
//
// Future<List<String>> getFavoriteBooks() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('favorites') ?? [];
//
// }
}
