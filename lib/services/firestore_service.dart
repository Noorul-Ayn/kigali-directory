import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'listings';

  Stream<List<ListingModel>> getListingsStream() {
    return _db
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ListingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<ListingModel>> getUserListingsStream(String uid) {
    return _db
        .collection(_collection)
        .where('createdBy', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ListingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> createListing(ListingModel listing) async {
    await _db.collection(_collection).add(listing.toMap());
  }

  Future<void> updateListing(String id, ListingModel listing) async {
    await _db.collection(_collection).doc(id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}