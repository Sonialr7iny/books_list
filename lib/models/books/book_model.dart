

class BookModel {
  final int id;
  final String name;
  final String author;
  final String imagePath;
  String description;

  BookModel({
    required this.id,
    required this.name,
    required this.author,
    required this.imagePath,
    required this.description,
  });
}
