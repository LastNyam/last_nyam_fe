import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(37.5665, 126.9780); // 초기 위치 (서울)
  final List<Map<String, dynamic>> _dummyStores = [
    {"name": "삼겹분식", "position": LatLng(37.5705, 126.9821)},
    {"name": "맛쟁이과일야채", "position": LatLng(37.5647, 126.9752)},
    {"name": "라공푸마라탕", "position": LatLng(37.5613, 126.9798)},
    {"name": "박가네과일", "position": LatLng(37.5680, 126.9840)},
    {"name": "고령축산", "position": LatLng(37.5624, 126.9732)},
  ];
  final List<Marker> _storeMarkers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    String permissionStatus = await checkPermission();

    if (permissionStatus == '위치 권한이 허가 되었습니다.') {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _addNearbyStores();
    }
  }

  void _addNearbyStores() {
    const double maxDistance = 4000; // 4km
    _storeMarkers.clear();

    for (var store in _dummyStores) {
      final storeLatLng = store["position"] as LatLng;
      final double distance = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        storeLatLng.latitude,
        storeLatLng.longitude,
      );

      if (distance <= maxDistance) {
        _storeMarkers.add(
          Marker(
            markerId: MarkerId(store["name"]),
            position: storeLatLng,
            infoWindow: InfoWindow(title: store["name"]),
          ),
        );
      }
    }

    setState(() {});
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가 되었습니다.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        markers: {
          ..._storeMarkers,
          Marker(
            markerId: MarkerId("current_location"),
            position: _currentPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: "내 위치"),
          ),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_currentPosition),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
