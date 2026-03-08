import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<ListingModel> _allListings = [];
  List<ListingModel> _userListings = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<ListingModel> get userListings => _userListings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<ListingModel> get filteredListings {
    return _allListings.where((l) {
      final matchesSearch =
          l.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l.address.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || l.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<ListingModel> get allListings => _allListings;

  void listenToAllListings() {
    _service.getListingsStream().listen((listings) {
      _allListings = listings;
      notifyListeners();
    }, onError: (e) {
      _errorMessage = e.toString();
      notifyListeners();
    });
  }

  void listenToUserListings(String uid) {
    _service.getUserListingsStream(uid).listen((listings) {
      _userListings = listings;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> createListing(ListingModel listing) async {
    _setLoading(true);
    try {
      await _service.createListing(listing);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateListing(String id, ListingModel listing) async {
    _setLoading(true);
    try {
      await _service.updateListing(id, listing);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      await _service.deleteListing(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}