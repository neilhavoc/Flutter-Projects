import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
import '../viewmodels/location_viewmodel.dart';

class ExpandableMapView extends ConsumerStatefulWidget {
  const ExpandableMapView({super.key});

  @override
  ConsumerState<ExpandableMapView> createState() => _ExpandableMapViewState();
}

class _ExpandableMapViewState extends ConsumerState<ExpandableMapView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final locationVM = ref.read(locationProvider.notifier);

    return GestureDetector(
      onTap: () {
        if (!isExpanded) {
          setState(() => isExpanded = true);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: isExpanded ? MediaQuery.of(context).size.height : 200, // small view when minimized
        child: Stack(
          children: [
            // Map View
            locationState == null || locationState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: locationState.position,
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: locationState.position,
                            child: const Icon(Icons.my_location, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),

            // Close button when expanded
            if (isExpanded)
              Positioned(
                top: 40,
                right: 20,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black.withOpacity(0.7),
                  onPressed: () => setState(() => isExpanded = false),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),

            // Refresh location button (always visible in corner)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                onPressed: () => locationVM.getCurrentLocation(),
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
