// In your shared/components/book_items_gridview.dart
// ... assuming bookItems is a function or a StatelessWidget/StatefulWidget

// If bookItems is a function:
import 'package:flutter/material.dart';

import '../../models/books/book_model.dart';

Widget bookItemss(BookModel_ book, bool isDarkMode, {Function(BookModel_ updatedBook)? onFavChanged}) {
  // ... your existing item UI ...
  return GestureDetector( // Or InkWell
    // ...
    child: Column(
      // ...
      children: [
        // ... your image, title, author ...
        IconButton(
          icon: Icon(book.isFav ? Icons.favorite : Icons.favorite_border),
          color: book.isFav ? Colors.red : null,
          onPressed: () {
            if (onFavChanged != null) {
              // Create a new BookModel instance with the toggled isFav status
              BookModel_ updatedBook = book.copyWith(isFav: !book.isFav);
              onFavChanged(updatedBook);
            }
          },
        ),
      ],
    ),
  );
}

// Then in HomeGridviewScreen's SliverChildBuilderDelegate:
// delegate: SliverChildBuilderDelegate(
//   (context, index) {
//     final book = filteredBooks[index];
//     return bookItems(
//       book,
//       widget.isDarkMode,
//       onFavChanged: (BookModel updatedBook) { // Pass the callback
//         _handleBookFavChanged(updatedBook);
//       },
//     );
//   },
//   childCount: filteredBooks.length,
// ),