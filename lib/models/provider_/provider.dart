import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../book_model/book_models.dart';
import '../books/book_model.dart';

class BooksProvider with ChangeNotifier {
  List<BookModel> _favorites = [];

  BooksProvider() {
    _loadFavorites();
  }

  final List<BookModel> _allBooks = books;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorites') ?? [];
    _favorites = _allBooks
        .where((book) => favoriteIds.contains(book.id.toString()))
        .toList();
    notifyListeners();
  }


  List<BookModel> get favoriteBooks {
    return _allBooks.where((book) => _favorites.contains(book)).toList();
  }

  //
  // Get the favorite books
  List<BookModel> get favorites => _favorites;

  //
  bool isFavorite(BookModel book) => _favorites.contains(book);

  void toggleFavorite(BookModel book) async {
    if (_favorites.contains(book)) {
      _favorites.remove(book);
    } else {
      _favorites.add(book);
    }
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds =
        _favorites.map((book) => book.id.toString()).toList();
    await prefs.setStringList('favorites', favoriteIds);
    notifyListeners();
  }
}
