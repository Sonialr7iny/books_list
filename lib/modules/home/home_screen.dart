import 'package:flutter/material.dart';

import '../../models/book_model/book_models.dart';
// import '../../models/books/book_model.dart';
import '../../shared/components/books_items.dart';
// import 'package:practicing_app/models/books/book_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });
  // const HomeScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload all images
    for (String imagePath in imageList) {
      precacheImage(AssetImage(imagePath), context);
      // precacheImage(NetworkImage('https://th.bing.com/th/id/R.cb40923173a100ca89e7baa84db8fda5?rik=S1sQ4cyWYAElgA&riu=http%3a%2f%2fmedia1.popsugar-assets.com%2ffiles%2f2014%2f04%2f30%2f217%2fn%2f1922398%2f0b301811bf66888f_thumb_temp_image346952781398917252%2fi%2fFault-Our-Stars-Introduction-Clip-Video.jpg&ehk=kWtUxnJ%2bUze8oZb5NzB574j2VUJouf%2bLvEg8b3%2f0zLo%3d&risl=&pid=ImgRaw&r=0'), context);
    }
  }

// Example list of image paths
  final List<String> imageList = [
    'images/albert.jpg',
    'images/fyodor.jpg',
    'images/hugo.jpg',
    'images/madonna.jpg',
    'images/utopia.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 20.0,
        // backgroundColor: Colors.blueGrey[50],
        title: Text(
          'Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            SizedBox(
              height: 500.0,
              child: ListView.separated(
                  itemBuilder: (context, index) => buildBookItem(books[index]),
                  separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        color: Colors.white,
                        height: 1.0,
                      ),
                  itemCount: books.length),
            ),
          ],
        ),
      ),
    );
  }
}
