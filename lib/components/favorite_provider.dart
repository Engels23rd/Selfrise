import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_proyecto_final/Design/libros/booksPage.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FavoriteProvider();
  Set<String> _favoriteBookIds = {};

Future<void> loadFavoriteBookIds(String userId) async {
    _favoriteBookIds.clear();
    final snapshot = await _firestore.collection('favorites').doc(userId).collection('books').get();
    for (var doc in snapshot.docs) {
      _favoriteBookIds.add(doc.id);
    }
    notifyListeners();
  }


  void toggleFavorite(Book book, String? userId) async {
    if (userId == null)return;
    try {
      final documentReference = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('books')
          .doc(book.id);
          if (_favoriteBookIds.contains(book.id)) {
      await documentReference.delete();
      _favoriteBookIds.remove(book.id);
    } else {
      await documentReference.set(book.toJson());
      _favoriteBookIds.add(book.id);
    }
      notifyListeners();
    } catch (error) {
      print('Error toggling favorite: $error');
    }
  }
    bool isFavorite(String bookId) {
    return _favoriteBookIds.contains(bookId);
  }
    Stream<List<Book>> streamFavorites(String userId) {
    return _firestore.collection('favorites').doc(userId).collection('books').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }


  Future<List<Book>> getFavorites(String? userId) async {
    List<Book> favoriteBooks = [];
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('books')
        .get();
    for (var doc in snapshot.docs) {
      Book book = Book.fromJson(doc.data() as Map<String, dynamic>);
      print("titulo del libro: ${book.title}");
      print("URL de la imagen del libro: ${book.thumbnailUrl}");
      favoriteBooks.add(book);
    }
    return favoriteBooks;
  }
  

  Future<void> clearFavorites(String? userId) async {
    if (userId == null) {
      print("Error: userId es null");
      return;
    }
    try {
      final querySnapshot = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('books')
          .get();

      for (var doc in (await querySnapshot).docs) {
        await doc.reference.delete();
      }
      notifyListeners();
    } catch (error) {
      print('Error clearing favorites: $error');
    }
  }

  Future<bool> isBookFavorite(String bookId, String? userId) async {
    if (userId == null) return false;

    try {
      final documentSnapshot = await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('books')
          .doc(bookId)
          .get();

      return documentSnapshot.exists; 
    } catch (error) {
      print('Error checking if book is favorite: $error');
      return false;
    }
  }

}