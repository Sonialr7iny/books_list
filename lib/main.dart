import 'package:flutter/material.dart';

import 'models/books/book_model.dart';
import 'models/books/book_model.dart';
import 'modules/book_details/book_details_screen.dart';
import 'modules/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: HomeScreen(),
        // BookDetailsScreen(
        //     book: BookModel(
        //   id: 1,
        //   name: "Welcome to Book App",
        //   author: "John Doe",
        //   description: "Start exploring books now.",
        //   bookImage: Image.asset('images/albert.jpg',)
        //     ),
        // ), // Placeholder image
        );
  }
}
