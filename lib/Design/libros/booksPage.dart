import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/libros/booksview.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/components/imageprovider.dart';
import 'package:flutter_proyecto_final/utils/ajustar_color_navigation_bar_icon.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../../components/favorite_provider.dart';
import 'booksController.dart';
import 'favoriteBooks.dart';
import '../../entity/authservice.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class Book {
  final String id; // Nuevo campo id
  final String title;
  final String subtitle;
  final List<String> authors;
  final String thumbnailUrl;
  final String publisher;
  final String publishedDate;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
    required this.subtitle,
    required this.description,
    required this.publisher,
    required this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> volumeInfo =
        json.containsKey('volumeInfo') ? json['volumeInfo'] : json;
    final title = volumeInfo['title'] as String? ?? 'Título Desconocido';
    final subtitle = volumeInfo['subtitle'] as String? ?? '';
    final authorsList = volumeInfo['authors'] as List<dynamic>? ?? [];
    final authors = authorsList.map((author) => author.toString()).toList();
    final imageLinks = volumeInfo.containsKey('imageLinks')
        ? volumeInfo['imageLinks'] as Map<String, dynamic>
        : {};
    final thumbnailUrl = imageLinks.isNotEmpty
        ? imageLinks['smallThumbnail']
        : volumeInfo['thumbnailUrl'] as String? ?? '';

    final publisher =
        volumeInfo['publisher'] as String? ?? 'Editorial Desconocida';
    final publishedDate = volumeInfo['publishedDate'] as String? ?? '';
    final description =
        volumeInfo['description'] as String? ?? 'Sin descripción';
    final id = json['id'] as String? ?? '';

    return Book(
      id: id,
      title: title,
      authors: authors,
      thumbnailUrl: thumbnailUrl,
      subtitle: subtitle,
      publisher: publisher,
      publishedDate: publishedDate,
      description: description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'thumbnailUrl': thumbnailUrl,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _futureBooks;
  final ScrollController _scrollController = ScrollController();
  final bookListController = BookListController.instance;
  TextEditingController searchbookcontroller = TextEditingController();
  List<Book> _books = [];
  List<bool> _isFavoriteList = [];
  // List<Book> _favoriteBooks = [];
  int _startIndex = 0;
  final int _maxResults = 10;
  bool _loading = false;
  String? userId;
  late Future<bool> isFavoriteFuture;

  @override
  void initState() {
    super.initState();
    _futureBooks = fetchBooks();
    ColorSystemNavitagionBar.setSystemUIOverlayStyleLight();
    _scrollController.addListener(_scrollListener);
    userId = AuthService.getUserId();
    Provider.of<FavoriteProvider>(context, listen: false)
        .loadFavoriteBookIds(userId!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    ColorSystemNavitagionBar.setSystemUIOverlayStyleDark();
    super.dispose();
  }

  Future<void> _searchBooks(String query) async {
    if (query.isNotEmpty) {
      final searchUrl =
          'https://www.googleapis.com/books/v1/volumes?q=intitle:$query+subject:health+body+mind';
      final response = await http.get(Uri.parse(searchUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['items'];
        final List<Book> searchResults =
            responseData.map((json) => Book.fromJson(json)).toList();

        setState(() {
          _books = searchResults;
          _futureBooks = Future.value(searchResults);
        });

        print('Resultados de la búsqueda:');
        print(_books);
        print(query);
      } else {
        throw Exception('Failed to search books');
      }
    } else {
      setState(() {
        _futureBooks = fetchBooks();
      });
    }
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=subject:health+body+mind&startIndex=$_startIndex&maxResults=$_maxResults'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['items'];
      return responseData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _fetchMoreBooks() async {
    try {
      final List<Book> moreBooks = await fetchBooks();
      setState(() {
        _books.addAll(moreBooks);
        _isFavoriteList.addAll(List.filled(moreBooks.length, false));
      });
    } catch (error) {
      print('Error fetching more books: $error');
    } finally {
      setState(() {
        _loading =
            false; // Establecer _loading en falso después de cargar los libros
      });
    }
  }

  void _scrollListener() {
    if (!_loading &&
        _scrollController.position.extentAfter < 200 &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _loading = true;
      });

      _startIndex += _maxResults;
      _fetchMoreBooks();
    }
  }

  PreferredSizeWidget? appBarCustom(
      String titulo, String? userId, bool leading) {
    print(userId);
    return AppBar(
      centerTitle: true,
      title: Text(titulo),
      actions: <Widget>[
        Consumer<FavoriteProvider>(
          builder: (context, provider, _) {
            return FutureBuilder<List<Book>>(
              future: provider.getFavorites(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  );
                } else if (snapshot.hasError) {
                  return IconButton(
                    icon: Icon(Icons.error),
                    onPressed: () {},
                  );
                } else {
                  final List<Book> favoriteBooks = snapshot.data ?? [];
                  return IconButton(
                    icon: Badge(
                      label: Text('${favoriteBooks.length}'),
                      child: const Icon(Icons.bookmark_border),
                    ),
                    tooltip: 'Libros favoritos',
                    onPressed: () {
                      final route = MaterialPageRoute(
                        builder: ((context) => const FavoritePage()),
                      );
                      Navigator.push(context, route);
                    },
                  );
                }
              },
            );
          },
        ),
      ],
      automaticallyImplyLeading: leading,
    );
  }

  int favoritelength(List<Book> favoriteBooks) {
    return favoriteBooks.length;
  }

  @override
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.drawer,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: CustomAppBar(
              titleText: "Libros recomendados",
              showBackButton: true,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchbookcontroller,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Buscar libros...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  _searchBooks(value);
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blueGrey,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  _books = snapshot.data!;
                  if (_isFavoriteList.length != _books.length) {
                    _isFavoriteList = List.filled(_books.length, false);
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _books.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _books.length) {
                        return const Center(
                          child: SpinKitFadingCircle(
                            color: Colors.blueGrey,
                            size: 50.0,
                          ),
                        );
                      } else {
                        final Book book = _books[index];
                        bool isFavorite = favoriteProvider.isFavorite(book.id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookViewPage(
                                  appBarCustom: appBarCustom(
                                      'Descripción de libros', userId, true),
                                  imageProvider: ImageUtils.getImageProvider(
                                      book.thumbnailUrl),
                                  title: book.title,
                                  subtitle: book.subtitle,
                                  authors: book.authors,
                                  publisher: book.publisher,
                                  publishedDate: book.publishedDate,
                                  description: book.description,
                                  book: book,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 140.0,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Container(
                                            width: 100.0,
                                            height: 120.0,
                                            color: Colors.grey[300],
                                            child: Image(
                                              image:
                                                  ImageUtils.getImageProvider(
                                                      book.thumbnailUrl),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  book.subtitle,
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  '- ${book.authors.join(',')}',
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            favoriteProvider.toggleFavorite(
                                                book, userId);
                                          },
                                          child: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? Colors.red
                                                : Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
