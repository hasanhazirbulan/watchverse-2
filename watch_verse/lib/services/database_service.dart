import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService._privateConstructor(); // Private constructor

  static final DatabaseService _instance =
  DatabaseService._privateConstructor();

  static DatabaseService get instance {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı oluştur
  Future<void> createUser({
    required String uid,
    required String email,
    String? name,
    String? profileImageUrl,
    // Diğer kullanıcı bilgileri
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'profileImageUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        // Diğer kullanıcı bilgileri
      });
    } catch (e) {
      print('Kullanıcı oluşturulurken hata oluştu: $e');
      // Hata yönetimi - örneğin, kullanıcıya hata mesajı gösterme
    }
  }

  // Kullanıcı bilgilerini al
// Fetch user data from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    try {
      // Fetch user document from Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      // Check if the document exists
      if (!userSnapshot.exists) {
        throw Exception('User document not found in Firestore.');
      }

      // Return the fetched document
      return userSnapshot;
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to fetch user data');
    }
  }


  // Kullanıcı bilgilerini güncelle
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Kullanıcı bilgileri güncellenirken hata oluştu: $e');
      // Hata yönetimi
    }
  }

  // Kullanıcı sil
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Kullanıcı silinirken hata oluştu: $e');
      // Hata yönetimi
    }
  }

  // Yeni bir belge oluştur (Create)
  Future<void> createDocument(
      String collectionName, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).add(data);
    } catch (e) {
      print('Belge oluşturulurken hata oluştu: $e');
      // Hata yönetimi - örneğin, kullanıcıya hata mesajı gösterme
    }
  }

  // Belge oku (Read)
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      String collectionName, String documentId) async {
    try {
      return await _firestore.collection(collectionName).doc(documentId).get();
    } catch (e) {
      print('Belge okunurken hata oluştu: $e');
      // Hata yönetimi
      rethrow;
    }
  }

  // Belge güncelle (Update)
  Future<void> updateDocument(
      String collectionName, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
    } catch (e) {
      print('Belge güncellenirken hata oluştu: $e');
      // Hata yönetimi
    }
  }

  // Belge sil (Delete)
  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      print('Belge silinirken hata oluştu: $e');
      // Hata yönetimi
    }
  }

  // Tüm belgeleri al (Read all)
  Stream<QuerySnapshot<Map<String, dynamic>>> getDocuments(
      String collectionName) {
    try {
      return _firestore.collection(collectionName).snapshots();
    } catch (e) {
      print('Belgeler alınırken hata oluştu: $e');
      // Hata yönetimi - örneğin, boş bir Stream döndürme
      rethrow;
    }
  }
}
