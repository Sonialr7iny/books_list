

import 'package:flutter/material.dart';

class BookModel {
  final int id;
  final String name;
  final String author;
  final Image bookImage;
  String description;

  BookModel({
    required this.id,
    required this.name,
    required this.author,
    required this.bookImage,
    required this.description,
  });
}
