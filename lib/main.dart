import 'package:flutter/material.dart';
import 'package:practicing_app/models/book_model/book_models.dart';
import 'package:practicing_app/shared/components/shared_preferences_helper.dart';
import 'package:provider/provider.dart';
// import 'package:practicing_app/models/book_model/book_models.dart';
// import 'package:provider/provider.dart';

// import 'models/books/book_model.dart';
// import 'models/books/book_model.dart';
// import 'modules/book_details/book_details_screen.dart';
// import 'modules/home/home_screen.dart';
// import 'models/provider/provider_basic.dart';
import 'models/books/book_model.dart';
import 'models/provider_/provider.dart';
import 'modules/book_details_provider/book_details_provider_shared.dart';
import 'modules/favorite_provider/favorites_provider_screen.dart';
import 'modules/home/home_screen.dart';
import 'modules/home_gridview/home_gridview_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesHelper();
  final isDarkMode = await prefs.getTheme();
  runApp(ChangeNotifierProvider(create:(_) => BooksProvider(),child: MyApp(isDarkMode: isDarkMode),));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  const MyApp({super.key,required, required this.isDarkMode});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void toggleTheme(bool isDarkMode) async {
    final prefs = SharedPreferencesHelper();
    await prefs.setTheme(isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: 'HomeGridview',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'HomeGridview':
            return MaterialPageRoute(
              builder: (context) => HomeGridviewScreen(
                toggleTheme: toggleTheme,
                isDarkMode: _isDarkMode,
              ),
            );
          case '/details':
            final book = settings.arguments as BookModel;
            return MaterialPageRoute(
              builder: (context) => BookDetailsScreenProvider(
                isDarkMode: _isDarkMode,
                toggleTheme: toggleTheme,
              ),
              settings: settings, // Pass settings to access arguments
            );
          case '/favorites':
            return MaterialPageRoute(
              builder: (context) => FavoritesScreenProvider(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => HomeScreen(),
            );
        }
      },
      // theme: ThemeData(
      //   useMaterial3: true,
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      // ),
      home:HomeGridviewScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
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
