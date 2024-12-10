import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/screen/near_by_store/loading.dart';
import 'package:last_nyam/screen/near_by_store/store_detail_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentPosition = null;
  bool _isLoading = true;
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();
  late List<dynamic> _storeList;
  Uint8List? _storeImage = null;
  final List<Marker> _storeMarkers = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final baseUrl = dotenv.env['BASE_URL'];
    final response = await _dio.get('$baseUrl/store');
    if (response.statusCode == 200) {
      _storeList = response.data['data'];
    }
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

  void _addNearbyStores() async {
    final userState = Provider.of<UserState>(context, listen: false);
    String? token = await _storage.read(key: 'authToken');
    const double maxDistance = 4000; // 4km
    _storeMarkers.clear();
    print('여기까진 성공');
    for (var store in _storeList) {
      final posX = double.parse(store["posX"]);
      final posY = double.parse(store['posY']);
      final double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        posX,
        posY,
      );
      print(distance);

      if (distance <= maxDistance) {
        _storeMarkers.add(
          Marker(
            markerId: MarkerId(store["storeName"]),
            position: LatLng(posX, posY),
            infoWindow: InfoWindow(
              title: store["storeName"],
            ),
            icon: BitmapDescriptor.fromBytes(
                await getBytesFromAsset('assets/image/marker.png', 70)),
            onTap: () async {
              Map<String, dynamic> storeInfo = {};
              try {
                final baseUrl = dotenv.env['BASE_URL'];
                final response = !userState.isLogin
                    ? await _dio.get('$baseUrl/store/${store['storeId']}')
                    : await _dio.get(
                        '$baseUrl/store/${store['storeId']}',
                        options: Options(
                          headers: {'Authorization': 'Bearer $token'},
                        ),
                      );
                if (response.statusCode == 200) {
                  storeInfo = response.data['data'];
                  print(storeInfo);
                  if (response.data['data']['storeImage'] != null) {
                    setState(() {
                      _storeImage = Uint8List.fromList(
                          base64Decode(response.data['data']['storeImage']));
                    });
                  } else {
                    setState(() {
                      _storeImage = null;
                    });
                  }
                }
                _showWithMarketDialog(
                    context, {'storeId': store['storeId'], ...storeInfo});
              } on DioError catch (e) {
                print('가게 상세 조회 실패: ${e.response?.data}');
              }
            },
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showWithMarketDialog(BuildContext context, Map<String, dynamic> store) {
    final userState = Provider.of<UserState>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLike = store['isLike']; // 좋아요 초기 상태

            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down_sharp,
                            size: 36.0, color: defaultColors['lightGreen']),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${store['storeName']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                userState.isLogin
                                    ? IconButton(
                                  onPressed: () async {
                                    try {
                                      final baseUrl =
                                      dotenv.env['BASE_URL'];
                                      String? token = await _storage.read(
                                          key: 'authToken');
                                      final response = !isLike
                                          ? await _dio.post(
                                        '$baseUrl/store/like',
                                        data: {
                                          'storeId':
                                          store['storeId'],
                                        },
                                        options: Options(
                                          headers: {
                                            'Authorization':
                                            'Bearer $token'
                                          },
                                        ),
                                      )
                                          : await _dio.delete(
                                        '$baseUrl/store/${store['storeId']}/like',
                                        options: Options(headers: {
                                          'Authorization':
                                          'Bearer $token'
                                        }),
                                      );

                                      if (response.statusCode == 200) {
                                        setState(() {
                                          isLike = !isLike; // 상태 토글
                                          store['isLike'] = isLike; // 업데이트된 상태 반영
                                        });
                                      }
                                    } on DioError catch (e) {
                                      print(
                                          '관심매장 등록 실패: ${e.response?.data}');
                                    }
                                  },
                                  icon: Icon(
                                    isLike
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLike
                                        ? defaultColors['green']
                                        : defaultColors['lightGreen'],
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Text(
                                  "${store['temperature']}°C",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: defaultColors['green'],
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: store['temperature'] / 100,
                                    // Progress (48.5%)
                                    backgroundColor:
                                    defaultColors['lightGreen'],
                                    color: defaultColors['green'],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _storeImage != null
                            ? Image.memory(
                          _storeImage!,
                          scale: 0.6,
                        )
                            : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(
                    color: defaultColors['lightGreen'],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: defaultColors['lightGreen']),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${store['address']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: defaultColors['lightGreen']),
                      SizedBox(width: 8),
                      Text(
                        "${store['callNumber']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreDetailScreen(
                              storeId: store['storeId'].toString(),
                              storeName: store['storeName'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: defaultColors['green'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '메뉴',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
      body: _isLoading
          ? LoadingScreen()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
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
            CameraUpdate.newLatLng(_currentPosition!),
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
