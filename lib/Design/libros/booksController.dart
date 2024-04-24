import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/libros/booksPage.dart';

class BookListController {
  static final instance = BookListController._();

  BookListController._();

  final ValueNotifier<Book?> removedBookNotifier = ValueNotifier<Book?>(null);
  final List<Book> favoriteBooks = [];

  void notifyBookRemoved(Book book) {
    removedBookNotifier.value = book;
    favoriteBooks.remove(book);
  }
}
