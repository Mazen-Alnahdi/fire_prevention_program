import 'dart:convert';
import 'package:fire_program/pages/info.dart';
import 'package:fire_program/services/fwi_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// import 'package:';

import '../widget/infoDialog.dart';

class Country {
  final String name;
  final double latitude;
  final double longitude;

  Country(
      {required this.name, required this.latitude, required this.longitude});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  LatLng? selectedLocation; // Store the selected location
  String? address; // Store the reverse-geocoded address
  double? temp, rh, wind, rain; // Store the FFMC values to calc
  double? FWI;
  FireWeatherIndex fwi = FireWeatherIndex();
  String result = "";
  final MapController _mapController = MapController();
  Country? selectedCountry = countries.isNotEmpty ? countries[0] : null;
  bool isResultsVisible = true; // Add state for results visibility

  final String key = dotenv.env["API_KEY"]!;
  final String user_agent = dotenv.env["USER_AGENT"]!;

  // Add new variables for risk areas
  final List<LatLng> highRiskAreas = [
    LatLng(29.5796, 47.8232), // Sabah Al-Ahmad Natural Reserve
    LatLng(29.3954, 47.5948), // Al-Shagaya Reserve
    LatLng(29.2270, 47.8790), // Um Al-Qaren Reserve
    LatLng(29.0471, 48.0253), // Mubarak Al-Kabeer Reserve
    LatLng(29.1750, 47.48166), // Al-Sulaibiya
  ];

  Color _getRiskColor(double fwi) {
    if (fwi >= 25.0) return Colors.red.withOpacity(0.7);
    if (fwi >= 15.0) return Colors.orange.withOpacity(0.7);
    if (fwi >= 7.0) return Colors.yellow.withOpacity(0.7);
    if (fwi >= 3.0) return Colors.green.withOpacity(0.7);
    return Colors.blue.withOpacity(0.7);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchAddressFromCoordinates(LatLng coords) async {
    // Show modal and start animation when fetching data
    setState(() {
      isResultsVisible = true;
    });
    _animationController.forward();

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json');

    final response = await http.get(url, headers: {
      'User-Agent': user_agent // Nominatim requires this
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        address = data['display_name'];
      });
    } else {
      setState(() {
        address = 'Error fetching address';
      });
    }

    final url2 = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?q=${coords.latitude}%2C%20${coords.longitude}&key=$key");

    try {
      final response = await http.get(url2);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          temp = (data['current']['temp_c'] as num).toDouble();
          rh = (data['current']['humidity'] as num).toDouble();
          wind = (data['current']['wind_kph'] as num).toDouble();
          rain = (data['current']['precip_mm'] as num).toDouble();

          FWI =
              fwi.calcFWI(temp!, rh!, wind!, rain!, selectedLocation!.latitude);
          if (FWI! < 3.0) {
            result = "خطر منخفض جدًا";
          } else if (FWI! >= 3.0 && FWI! < 7.0) {
            result = "خطر منخفض";
          } else if (FWI! >= 7.0 && FWI! < 15.0) {
            result = "خطر معتدل";
          } else if (FWI! >= 15.0 && FWI! < 25.0) {
            result = "خطر كبير";
          } else if (FWI! >= 25.0) {
            result = "خطر كبير جدًا";
          }
        });
      } else {
        setState(() {
          temp = 0;
          rh = 0;
          wind = 0;
          rain = 0;
          FWI = 0;
        });
      }
    } catch (e) {
      setState(() {
        temp = 0;
        rh = 0;
        wind = 0;
        rain = 0;
        FWI = 0;
      });
    }
  }

  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog if location services are disabled
      _showLocationDialog(
        context,
        'خدمة الموقع معطلة',
        'يرجى تمكين خدمات الموقع للمتابعة.',
      );
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show dialog if permissions are denied
        _showLocationDialog(
          context,
          'تم رفض إذن الموقع',
          'يرجى منح أذونات الموقع للمتابعة.',
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Show dialog if permissions are permanently denied
      _showLocationDialog(
        context,
        'تم رفض إذن الموقع بشكل دائم',
        'أذونات الموقع مرفوضة بشكل دائم. يرجى تمكينها في إعدادات التطبيق.',
      );
      return Future.error('Location permissions are permanently denied.');
    }

    // Request temporary full accuracy for iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await Geolocator.requestTemporaryFullAccuracy(
        purposeKey: "LocationAccuracy",
      );
    }

    // If everything is fine, return the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _showLocationDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف الحرائق'),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Info()));
              },
              icon: const Icon(Icons.info_outline))
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(29.3757, 47.9773),
              initialZoom: 9.0, // Zoomed out to show more area
              onTap: (tapPosition, point) async {
                setState(() {
                  selectedLocation = point;
                });
                await fetchAddressFromCoordinates(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.fire_prevention_program',
                maxZoom: 19,
                tileProvider: NetworkTileProvider(),
              ),
              // Add circles for high-risk areas
              CircleLayer(
                circles: highRiskAreas.map((location) {
                  return CircleMarker(
                    point: location,
                    radius: 2000, // 2km radius
                    useRadiusInMeter: true,
                    color: Colors.red.withOpacity(0.3),
                    borderColor: Colors.red,
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      child: Icon(
                        Icons.location_on,
                        color: FWI != null ? _getRiskColor(FWI!) : Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.orange, // Background color for the dropdown box
                borderRadius:
                    BorderRadius.circular(5), // Optional: Rounded corners
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Keep spacing consistent
                children: [
                  // Icon(
                  //   Icons.arrow_drop_down,
                  //   color: Colors.black, // Dropdown arrow icon color
                  // ),
                  Expanded(
                    child: DropdownButton<Country>(
                      isExpanded:
                          true, // Ensures the dropdown stretches to fit the text alignment
                      alignment:
                          Alignment.centerRight, // Aligns text to the right
                      hint: const Text(
                        "اختر دولة",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black, // Hint text color
                        ),
                      ),
                      value: selectedCountry,
                      items: getDropdownItems(),
                      onChanged: (Country? newValue) {
                        setState(() {
                          selectedCountry = newValue;
                          selectedLocation = LatLng(
                              newValue!.latitude,
                              newValue
                                  .longitude); // Set location based on selected country
                          _mapController.move(selectedLocation!,
                              10.0); // Move the map to the selected country location
                        });
                        fetchAddressFromCoordinates(
                            selectedLocation!); // Fetch address for the selected country
                      },
                      dropdownColor:
                          Colors.orange, // Dropdown menu background color
                      style: const TextStyle(
                        color: Colors
                            .black, // Text color for selected and dropdown items
                        // textAlign: TextAlign.right, // Aligns text to the right
                      ),
                      underline: Container(), // Removes the default underline
                      icon: const Icon(
                        Icons.arrow_drop_down, // Custom icon
                        color: Colors.black, // Dropdown arrow icon color
                      ),
                      iconSize: 24, // Size of the icon
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 100,
              left: 20,
              right: 20,
              child: SlideTransition(
                position: _slideAnimation,
                child: Visibility(
                  visible: isResultsVisible,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.orange,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                _animationController.reverse().then((_) {
                                  setState(() {
                                    isResultsVisible = false;
                                  });
                                });
                              },
                            ),
                            const Text(
                              "احتمال نشوب حريق اليوم هو",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                                width: 48), // Balance the close button
                          ],
                        ),
                        if (address != null) ...[
                          Text(
                            result,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoTile("درجة الحرارة", "$temp\u00b0C"),
                              _buildInfoTile("رطوبة", "$rh%"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoTile("رياح", "${wind}kph"),
                              _buildInfoTile("مطر", "${rain}mm"),
                            ],
                          ),
                          _buildInfoTile("العنوان", address ?? ""),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    InfoDialog(fwi: FWI ?? 0.0),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 32,
                                ),
                              ),
                            ),
                            child: const Text(
                              'عرض المعلومات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!isResultsVisible && selectedLocation != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 100,
              right: 20,
              child: FloatingActionButton(
                heroTag: "show_results_fab",
                onPressed: () {
                  setState(() {
                    isResultsVisible = true;
                  });
                  _animationController.forward();
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.visibility, color: Colors.white),
              ),
            ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: "location_fab",
              onPressed: () async {
                final position = await _determinePosition(context);
                final userLocation = LatLng(
                  position.latitude,
                  position.longitude,
                );
                setState(() {
                  selectedLocation = userLocation;
                });
                _mapController.move(userLocation, 10.0);
                await fetchAddressFromCoordinates(userLocation);
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.place, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: "call_fab",
              onPressed: () async {
                final phoneNumber = '112';
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  // For iOS, use the standard tel: scheme
                  final Uri telUrl = Uri(scheme: 'tel', path: phoneNumber);

                  try {
                    if (await canLaunchUrl(telUrl)) {
                      await launchUrl(
                        telUrl,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    } else {
                      if (mounted) {
                        _showEmergencyDialog(context);
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      _showEmergencyDialog(context);
                    }
                  }
                } else {
                  // For Android and other platforms
                  final Uri url = Uri.parse('tel:$phoneNumber');
                  try {
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.platformDefault);
                    } else {
                      if (mounted) {
                        _showEmergencyDialog(context);
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      _showEmergencyDialog(context);
                    }
                  }
                }
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.phone, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Flexible(
      child: ListTile(
        title: Text(
          "$label\n$value",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text(
            'خطأ',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'غير قادر على إجراء المكالمة. يرجى الاتصال بالطوارئ يدويًا على الرقم 112',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'حسناً',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

List<Country> countries = [
  Country(
      name: "محمية صباح الأحمد الطبيعية",
      latitude: 29.5796,
      longitude: 47.8232),
  Country(name: "محمية الشقايا", latitude: 29.3954, longitude: 47.5948),
  Country(name: "محمية أم القرين", latitude: 29.2270, longitude: 47.8790),
  Country(name: "محمية مبارك الكبير", latitude: 29.0471, longitude: 48.0253),
  Country(name: "محمية الصليبية", latitude: 29.1750, longitude: 47.48166),
];
List<DropdownMenuItem<Country>> getDropdownItems() {
  return countries.map((Country country) {
    return DropdownMenuItem<Country>(
      value: country,
      child: Align(
        alignment: Alignment.centerRight, // Align the child widget to the right
        child: Text(
          country.name,
          textAlign: TextAlign.right, // Align the text to the right
          textDirection:
              TextDirection.rtl, // Ensure proper text direction for Arabic
          style: const TextStyle(
            color: Colors.black, // Text color
          ),
        ),
      ),
    );
  }).toList();
}
