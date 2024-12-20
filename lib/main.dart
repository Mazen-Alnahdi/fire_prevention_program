import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapPickerExample extends StatefulWidget {
  @override
  _MapPickerExampleState createState() => _MapPickerExampleState();
}

class _MapPickerExampleState extends State<MapPickerExample> {
  LatLng? selectedLocation; // Store the selected location
  String? address; // Store the reverse-geocoded address

  Future<void> fetchAddressFromCoordinates(LatLng coords) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json');
    final response = await http.get(url, headers: {
      'User-Agent': 'flutter_map_picker_example/1.0' // Nominatim requires this
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Picker Example'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(51.5074, -0.1278),// Default to London
              initialZoom: 13.0,
              onTap: (tapPosition, point) async {
                setState(() {
                  selectedLocation = point;
                });
                await fetchAddressFromCoordinates(point); // Fetch the address
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      child:  Icon(
                        Icons.location_on, // A default location icon
                        color: Colors.red, // Red color for the marker
                        size: 40, // Set the size of the icon
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selected Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lat: ${selectedLocation!.latitude}, Lon: ${selectedLocation!.longitude}',
                    ),
                    if (address != null)
                      Text(
                        'Address: $address',
                        style: TextStyle(color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapPickerExample(),
  ));
}
