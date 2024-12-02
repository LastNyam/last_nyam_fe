import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/screen/near_by_store/loading.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(37.5665, 126.9780); // 초기 위치 (서울)
  bool _isRendering = false;
  bool _isLoading = true;
  final List<Map<String, dynamic>> _dummyStores = [
    {"name": "삼첩분식", "position": LatLng(36.1455956, 128.3926275)},
    {"name": "멋쟁이과일야채", "position": LatLng(36.1455864, 128.3926456)},
    {"name": "라쿵푸마라탕", "position": LatLng(36.1455856, 128.3926487)},
    {"name": "박가네과일", "position": LatLng(36.1455974, 128.3926217)},
    {"name": "고령축산", "position": LatLng(36.1455996, 128.3926515)},
  ];
  final List<Marker> _storeMarkers = [];
  // final Circle circle = Circle(
  //   circleId: CircleId('Me'),
  //   center:
  // );

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // 1초 동안 로딩 화면 유지
    _getCurrentLocation();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isRendering = true;
    });
  }

  void _getCurrentLocation() async {
    String permissionStatus = await checkPermission();

    if (permissionStatus == '위치 권한이 허가 되었습니다.') {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      await _mapController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
      print('현 위치: ${position.latitude}, ${position.longitude}');

      _addNearbyStores();

      setState(() {
        _isLoading = false;
      });
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
      body: _isLoading == true && _isRendering == false
          ? LoadingScreen()
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: true,
        rotateGesturesEnabled: false,
        zoomControlsEnabled: false,
        buildingsEnabled: false,
        markers: {
          ..._storeMarkers,
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
        backgroundColor: Colors.white, // 버튼 배경색
        child: Icon(
          Icons.my_location, // 아이콘 모양
          color: defaultColors['green'], // 아이콘 색상
          size: 32, // 아이콘 크기
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // 버튼을 완전한 원형으로 설정
        ),
      ),
    );
  }
}