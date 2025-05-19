import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practicing_app/models/books/book_model.dart';
import 'package:practicing_app/services/secure_book_storage.dart'; // Import the new service
import '../../shared/components/book_item_gridview_encrypt.dart';
import '../../shared/components/book_items_gridview.dart'; // Your existing component

class HomeGridviewEncryptScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomeGridviewEncryptScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeGridviewEncryptScreen> createState() => _HomeGridviewEncryptScreenState();
}

class _HomeGridviewEncryptScreenState extends State<HomeGridviewEncryptScreen> {
  List<BookModel_> filteredBooks = [];
  TextEditingController txtController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<BookModel_> books = []; // This will be loaded from secure storage

  bool _isLoading = true; // To show a loading indicator

  // This is your original imageList for precaching.
  // Consider if this should also be driven by the loaded book data.
  final List<String> staticImageListForPrecache = [
    'images/albert.jpg',
    'images/fyodor.jpg',
    'images/hugo.jpg',
    'images/madonna.jpg',
    'images/utopia.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadBooksFromStorage();
  }

  Future<void> _loadBooksFromStorage() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    List<BookModel_> loadedBooks = (await SecureBookStorage.loadBooks()).cast<BookModel_>();
    if (mounted) { // Always check if the widget is still mounted before calling setState
      setState(() {
        if (loadedBooks.isEmpty) {
          // If no books in storage, load your default/initial set
          // And then save them so they are there next time
          books = _getDefaultBooks().cast<BookModel_>(); // Create a helper for your default books
          SecureBookStorage.saveBooks(books); // Save them for next time
          if (kDebugMode) {
            print("No books in storage, loaded default books and saved them.");
          }
        } else {
          books = loadedBooks.cast<BookModel_>();
          if (kDebugMode) {
            print("Loaded ${books.length} books from storage.");
          }
        }
        filteredBooks = books.cast<BookModel_>();
        _isLoading = false;
      });
      _precacheBookImages(); // Precache images after books are loaded
    }
  }

  // Helper to get your initial set of books if storage is empty
  List<BookModel_> _getDefaultBooks() {
    return [
      BookModel_(
        name: "The Stranger",
        author: "Albert Camus",
        imagePath: "images/albert.jpg",
        description: "A profound novel exploring themes of alienation and the absurd.",
      ),
      BookModel_(
        name: "Crime and Punishment",
        author: "Fyodor Dostoevsky",
        imagePath: "images/fyodor.jpg",
        description: "A psychological novel about guilt and redemption.",
      ),
      BookModel_(
        name: "Les Misérables",
        author: "Victor Hugo",
        imagePath: "images/hugo.jpg",
        description: "An epic historical novel of justice, love, and sacrifice.",
      ),
      BookModel_(
        name: "The Life of Madonna",
        author: "Various",
        imagePath: "images/madonna.jpg",
        description: "A biography or exploration of Madonna's impact.",
      ),
      BookModel_(
        name: "Utopia",
        author: "Thomas More",
        imagePath: "images/utopia.jpg",
        description: "A work of fiction and socio-political satire.",
      ),
    ];
  }


  // You'll need a way to trigger saving, e.g., when a book's 'isFav' changes.
  // For this example, let's assume 'bookItems' widget calls a callback when fav status changes.


  // Update didChangeDependencies for precaching based on loaded books
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-caching is now handled by _precacheBookImages after books are loaded
    // If you still want to precache the static list early:
    // _precacheStaticImages();
  }

  void _precacheBookImages() {
    if (books.isEmpty) return;
    for (BookModel_ book in books) {
      if (book.imagePath.isNotEmpty) {
        precacheImage(AssetImage(book.imagePath), context);
      }
    }
    if (kDebugMode) {
      print("Precached images for loaded books.");
    }
  }



  @override
  void dispose() {
    txtController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // print("Building HomeGridviewScreen. isDarkMode: ${widget.isDarkMode}, isLoading: $_isLoading, Books count: ${books.length}");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(
            onPressed: () {
              widget.toggleTheme(!widget.isDarkMode);
            },
            icon: widget.isDarkMode
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          ),
          // Optional: Add a button to clear storage for testing
          if (kDebugMode)
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.red),
              tooltip: "Clear Stored Books (Debug)",
              onPressed: () async {
                await SecureBookStorage.clearStoredBooks();
                _loadBooksFromStorage(); // Reload (should load defaults)
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: txtController,
                  focusNode: searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            filteredBooks = books.cast<BookModel_>();
                            txtController.clear();
                            searchFocusNode.unfocus();
                          });
                        },
                        icon: const Icon(Icons.clear)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        width: 2.0,
                        color: widget.isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                          width: 1.0,
                          color: widget.isDarkMode ? Colors.white38 : Colors.black38),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      if (query.isEmpty) {
                        filteredBooks = books.cast<BookModel_>();
                      } else {
                        filteredBooks = books
                            .where((book) =>
                        book.name
                            .toLowerCase()
                            .contains(query.toLowerCase()) ||
                            book.author
                                .toLowerCase()
                                .contains(query.toLowerCase())).cast<BookModel_>()
                            .toList();
                      }
                    });
                  }),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                // You'll need to modify 'bookItems' to accept a callback for when fav status changes
                // For now, let's assume it doesn't and we only save on major events (less ideal)
                // Ideally, bookItems would have something like:
                // onFavChanged: (BookModel bookWithNewFavStatus) {
                //   _handleBookFavChanged(bookWithNewFavStatus);
                // }
                return bookItemss(filteredBooks[index] as BookModel_, widget.isDarkMode);
              },
              childCount: filteredBooks.length,
            ),
          ),
        ],
      ),
    );
  }
}