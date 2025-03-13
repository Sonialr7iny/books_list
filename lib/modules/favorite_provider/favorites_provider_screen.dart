
import 'package:flutter/material.dart';
import 'package:practicing_app/modules/book_details_provider/book_details_provider_shared.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/provider_/provider.dart';

class FavoritesScreenProvider extends StatelessWidget {
  const FavoritesScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    final favoriteBooks = booksProvider.favoriteBooks;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body:  Consumer<BooksProvider>(
        builder: (context, provider, child) {
          if (favoriteBooks.isEmpty) {
            return Center(child: Text("No favorites"));
          }
          return ListView.builder(
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];
              return ListTile(
                title: Text(book.name),
                subtitle: Text(book.author),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child:Image.asset(book.imagePath) // Show book image
                ),
                onTap: (){
                 Navigator.pushNamed(context, '/details',arguments: book);
                },
              );
            },
          );
        },
      ),
    );
  }
}