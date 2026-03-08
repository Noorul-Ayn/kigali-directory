import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing_model.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;

  const ListingDetailScreen({super.key, required this.listing});

  Future<void> _launchMaps() async {
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.name),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder
            Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Map preview coming soon',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(listing.category),
                    backgroundColor:
                        const Color(0xFF00A86B).withOpacity(0.15),
                    labelStyle:
                        const TextStyle(color: Color(0xFF00A86B)),
                  ),
                  const SizedBox(height: 16),
                  _infoRow(Icons.location_on_outlined, listing.address),
                  const SizedBox(height: 12),
                  _infoRow(Icons.phone_outlined, listing.contactNumber),
                  const SizedBox(height: 12),
                  _infoRow(Icons.description_outlined, listing.description),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.my_location,
                    '${listing.latitude.toStringAsFixed(4)}, ${listing.longitude.toStringAsFixed(4)}',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _launchMaps,
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions',
                          style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A86B),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF00A86B), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15)),
        ),
      ],
    );
  }
}