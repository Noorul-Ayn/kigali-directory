import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/auth_provider.dart';
import '../providers/listings_provider.dart';

class AddEditListingScreen extends StatefulWidget {
  final ListingModel? listing;

  const AddEditListingScreen({super.key, this.listing});

  @override
  State<AddEditListingScreen> createState() => _AddEditListingScreenState();
}

class _AddEditListingScreenState extends State<AddEditListingScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  String _selectedCategory = ListingModel.categories.first;
  bool get _isEditing => widget.listing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final l = widget.listing!;
      _nameController.text = l.name;
      _addressController.text = l.address;
      _contactController.text = l.contactNumber;
      _descriptionController.text = l.description;
      _latController.text = l.latitude.toString();
      _lngController.text = l.longitude.toString();
      _selectedCategory = l.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
  // Validate name
  if (_nameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a place or service name')),
    );
    return;
  }
  // Validate address
  if (_addressController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter an address')),
    );
    return;
  }
  // Validate coordinates
  if (_latController.text.trim().isEmpty || _lngController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter latitude and longitude')),
    );
    return;
  }
  final lat = double.tryParse(_latController.text.trim());
  final lng = double.tryParse(_lngController.text.trim());
  if (lat == null || lng == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coordinates must be valid numbers')),
    );
    return;
  }
  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter valid geographic coordinates')),
    );
    return;
  }

  final uid = context.read<AuthProvider>().user!.uid;
  final provider = context.read<ListingsProvider>();

  final listing = ListingModel(
    id: widget.listing?.id,
    name: _nameController.text.trim(),
    category: _selectedCategory,
    address: _addressController.text.trim(),
    contactNumber: _contactController.text.trim(),
    description: _descriptionController.text.trim(),
    latitude: lat,
    longitude: lng,
    createdBy: uid,
    timestamp: widget.listing?.timestamp ?? DateTime.now(),
  );

  if (_isEditing) {
    await provider.updateListing(widget.listing!.id!, listing);
  } else {
    await provider.createListing(listing);
  }

  if (mounted) Navigator.pop(context);
}

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Listing' : 'Add Listing'),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, 'Place/Service Name *',
                Icons.business),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              items: ListingModel.categories
                  .map((cat) =>
                      DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) =>
                  setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 16),
            _buildTextField(
                _addressController, 'Address *', Icons.location_on_outlined),
            const SizedBox(height: 16),
            _buildTextField(
                _contactController, 'Contact Number', Icons.phone_outlined,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Description',
                Icons.description_outlined,
                maxLines: 3),
            const SizedBox(height: 16),
            const Text('Geographic Coordinates *',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              'Tip: Find coordinates on Google Maps by long-pressing a location.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      _latController, 'Latitude *', Icons.my_location,
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                      _lngController, 'Longitude *', Icons.my_location,
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  foregroundColor: Colors.white,
                ),
                child: Text(_isEditing ? 'Update Listing' : 'Add Listing',
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}