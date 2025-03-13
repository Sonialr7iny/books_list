import 'package:flutter/material.dart';
import 'package:practicing_app/models/books/book_model.dart';
import 'package:practicing_app/shared/components/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/book_model/book_models.dart';
import '../../shared/components/book_items_gridview.dart';

class HomeGridviewScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomeGridviewScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeGridviewScreen> createState() => _HomeGridviewScreenState();
}

class _HomeGridviewScreenState extends State<HomeGridviewScreen> {
  List<BookModel> filteredBooks = [];
  TextEditingController txtController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<BookModel> Books = [];
  bool isDarkMode = true;

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
  void dispose() {
    txtController.dispose();
    searchFocusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    filteredBooks = books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: [

          IconButton(onPressed: () {
            widget.toggleTheme(!widget.isDarkMode);
            print("Is Dark Mode: ${widget.isDarkMode}"); // Debugging
            setState(() {
              print("Is Dark Mode: ${widget.isDarkMode}"); // Debugging
              isDarkMode = widget.isDarkMode;
            });
            print("Is Dark Mode: ${widget.isDarkMode}"); // Debugging
          }, icon:isDarkMode? Icon(Icons.light_mode):Icon(Icons.dark_mode),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
      SliverToBoxAdapter(
         child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: txtController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          filteredBooks = books;
                          txtController.clear();
                          searchFocusNode.unfocus();
                        });
                      },
                      icon: Icon(Icons.clear)),
                  border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: isDarkMode?Colors.black:Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: isDarkMode?Colors.black:Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(width: 1.0,
                    color: isDarkMode?Colors.black:Colors.white),
                  ),
                ),
                onChanged: (query) {
                  print(query);
                  setState(() {
                    filteredBooks = books
                        .where((book) =>
                            book.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            book.author
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .toList();
                  });
                }),
          ),),
          // SizedBox(
          //   height: 10.0,
          // ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return bookItems(filteredBooks[index],isDarkMode);
              },
              childCount: filteredBooks.length,
            ),
            // itemCount: filteredBooks.length,
            // primary: false,
            // itemBuilder: (context, index) => bookItems(filteredBooks[index]),
          ),

        ],
      ),
    );
  }



}

