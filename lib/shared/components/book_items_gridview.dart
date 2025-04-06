import 'package:flutter/material.dart';
import 'package:practicing_app/models/books/book_model.dart';
import 'package:provider/provider.dart';
import '../../models/provider_/provider.dart';

Widget bookItems(BookModel book,bool isDarkMode) =>
    Consumer<BooksProvider>(builder: (context, provider, child) {
      return Container(
        height: 400.0,
        width: 400.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(2, 2),
              spreadRadius: 2,
            ),
          ],
        ),
        // color: Colors.white12,
        child: Column(
          children: [
            SizedBox(
              width: 150.0,
              height: 200.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(book.imagePath)
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => BookDetailsScreenProvider(
                //       isDarkMode: widget.isDarkMode, // Pass the current isDarkMode state
                //       toggleTheme: widget.toggleTheme, // Pass the toggleTheme function
                //     ),
                //   ),
                // );

                Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: book, // Pass the book as an argument
                  );

              },
              child: Text(
                book.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BlackChancery',
                  fontSize: 18.0,
                  color: isDarkMode?Colors.black:Colors.black
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    });
