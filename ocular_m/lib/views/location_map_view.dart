import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
import '../viewmodels/location_viewmodel.dart';

class LocationMapView extends ConsumerWidget {
  const LocationMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);
    final locationVM = ref.read(locationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xAA222f3e),
        title: Text("Emergency Locator", style: TextStyle(color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => locationVM.getCurrentLocation(),
          ),
        ],
      ),
      body: locationState == null || locationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: locationState.position,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: locationState.position,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
