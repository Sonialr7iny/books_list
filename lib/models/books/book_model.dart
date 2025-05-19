

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


class BookModel_ {
  String name;
  String imagePath;
  String author;
  String description;
  bool isFav;

  BookModel_({
    required this.name,
    required this.imagePath,
    required this.author,
    required this.description,
    this.isFav = false,
  });

  // Convert a BookModel instance to a Map (for JSON serialization)
  Map<String, dynamic> toJson() => {
    'name': name,
    'imagePath': imagePath,
    'author': author,
    'description': description,
    'isFav': isFav,
  };

  // Create a BookModel instance from a Map (from JSON deserialization)
  factory BookModel_.fromJson(Map<String, dynamic> json) => BookModel_(
    name: json['name'] as String,
    imagePath: json['imagePath'] as String,
    author: json['author'] as String,
    description: json['description'] as String,
    // Provide a default value if 'isFav' might be null in stored data
    isFav: json['isFav'] as bool? ?? false,
  );

  // Optional: A copyWith method can be useful for updating instances
  BookModel_ copyWith({
    String? name,
    String? imagePath,
    String? author,
    String? description,
    bool? isFav,
  }) {
    return BookModel_(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      author: author ?? this.author,
      description: description ?? this.description,
      isFav: isFav ?? this.isFav,
    );
  }
}
