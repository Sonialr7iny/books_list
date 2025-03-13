import 'package:flutter/material.dart';
import 'package:practicing_app/main.dart';
import 'package:practicing_app/models/books/book_model.dart';
import '../../modules/book_details/book_details_screen.dart';


Widget buildBookItem(BookModel book) => Container(
      color: Colors.grey[200],
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 6,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              height: 200.0,
              // في buildBookItem:
              child: Hero(
                tag: 'book_${book.id}',
                child:Image.asset(book.imagePath)
              ),
              // width: 100.0,

            ),
          ),
          SizedBox(
            width: 1.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigatorKey.currentState?.push(MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(book: book,)));
                    },
                    child: Text(
                      book.description,
                      style: TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
