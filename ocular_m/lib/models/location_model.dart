import 'package:latlong2/latlong.dart';

class LocationModel {
  final LatLng position;
  final bool isLoading;

  LocationModel({
    required this.position,
    this.isLoading = false,
  });

  LocationModel copyWith({LatLng? position, bool? isLoading}) {
    return LocationModel(
      position: position ?? this.position,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
