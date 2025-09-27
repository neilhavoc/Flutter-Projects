import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';

class LocationViewModel extends StateNotifier<LocationModel?> {
  LocationViewModel() : super(null);

  Future<void> getCurrentLocation() async {
    // Set loading state
    state = LocationModel(
      position: LatLng(0, 0),
      isLoading: true,
    );

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Optionally: show user a message to enable location
      state = LocationModel(
        position: LatLng(0, 0),
        isLoading: false,
      );
      return;
    }

    // Check and request permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = LocationModel(
          position: LatLng(0, 0),
          isLoading: false,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = LocationModel(
        position: LatLng(0, 0),
        isLoading: false,
      );
      return;
    }

    // New LocationSettings API
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // high accuracy GPS
      distanceFilter: 5,               // only update if moved 5 meters
    );

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // Update state with current location
    state = LocationModel(
      position: LatLng(position.latitude, position.longitude),
      isLoading: false,
    );
  }
}

// Riverpod provider
final locationProvider =
    StateNotifierProvider<LocationViewModel, LocationModel?>(
        (ref) => LocationViewModel());
