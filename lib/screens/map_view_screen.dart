import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/listing_model.dart';
import 'listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _mapController;

  static const LatLng _kigaliCenter = LatLng(-1.9441, 30.0619);

  Set<Marker> _buildMarkers(List<ListingModel> listings) {
    return listings.map((listing) {
      return Marker(
        markerId: MarkerId(listing.id ?? listing.name),
        position: LatLng(listing.latitude, listing.longitude),
        infoWindow: InfoWindow(
          title: listing.name,
          snippet: listing.category,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListingDetailScreen(listing: listing),
            ),
          ),
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<ListingsProvider>().allListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _kigaliCenter,
          zoom: 13,
        ),
        markers: _buildMarkers(listings),
        onMapCreated: (controller) => _mapController = controller,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}