

import 'dart:convert';
import 'package:fire_program/services/fwi_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  LatLng? selectedLocation; // Store the selected location
  String? address; // Store the reverse-geocoded address
  double? temp, rh, wind, rain; //Store the FFMC values to calc
  double? FWI;
  FireWeatherIndex fwi = new FireWeatherIndex();
  String result="";

  Color textColor = Colors.black;

  final String key= dotenv.env["API_KEY"]!;

  Future<void> fetchAddressFromCoordinates(LatLng coords) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json');
    String user_agent = dotenv.env["USER_AGENT"]!;
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

    final url2 = Uri.parse("https://api.weatherapi.com/v1/current.json?q=${coords.latitude}%2C%20${coords.longitude}&key=${key}");

    try {
      final response = await http.get(url2);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {

          // fixes the error --> "type 'int' is not a subtype of type 'double?'"
          temp = (data['current']['temp_c'] is int)
              ? (data['current']['temp_c'] as int).toDouble()
              : data['current']['temp_c'];
          rh = (data['current']['humidity'] is int)
              ? (data['current']['humidity'] as int).toDouble()
              : data['current']['humidity'];
          wind = (data['current']['wind_kph'] is int)
              ? (data['current']['wind_kph'] as int).toDouble()
              : data['current']['wind_kph'];
          rain = (data['current']['precip_mm'] is int)
              ? (data['current']['precip_mm'] as int).toDouble()
              : data['current']['precip_mm'];



          FWI=fwi.calcFWI(temp!, rh!, wind!, rain!, selectedLocation!.latitude);
          if(FWI!<5.2){
            result="Very Low Danger";
          } else if(FWI!>=5.2&&FWI!<11.2){
            result="Low Danger";
          } else if(FWI!>=11.2&&FWI!<21.3){
            result="Moderate Danger";
          } else if(FWI!>=21.3&&FWI!<38.0){
            result="High Danger";
          } else if(FWI!>=38.0&&FWI!<50){
            result="Very High Danger";
          } else {
            result="NO DATA GIVEN";
          }

        });
      } else {
        setState(() {
          temp = 0;
          rh = 0;
          wind = 0;
          rain = 0;
          FWI=0;

        });
      }
    } catch (e) {
      setState(() {
        temp = 0;
        rh = 0;
        wind = 0;
        rain = 0;
        FWI=0;

      });
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire Detection'),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(29.3757, 47.9773),// Default to Kuwait City
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
                      child:  const Icon(
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
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.orange,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          backgroundColor: Colors.transparent,
                          collapsedBackgroundColor: Colors.transparent,
                          title: Column(
                            children: [
                              if (address != null)
                                const Text(
                                  "Today's Probability of a Fire is",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true, // Ensures the text wraps if it’s too long
                                ),
                              Text(
                                "$result",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                                softWrap: true, // Ensures the text wraps if it’s too long
                                overflow: TextOverflow.visible, // Prevents text overflow
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        title: Text(
                                          "Temperature:\n${temp}\u00b0C",
                                          textAlign: TextAlign.center, // Centers the text
                                          style: TextStyle(color: Colors.black),
                                          softWrap: true, // Ensures text wraps on overflow
                                          overflow: TextOverflow.visible, // Allows text to wrap and show without truncation
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: ListTile(
                                        title: Text(
                                          "Humidity:\n${rh}%",
                                          textAlign: TextAlign.center, // Centers the text
                                          style: TextStyle(color: Colors.black),
                                          softWrap: true, // Ensures text wraps on overflow
                                          overflow: TextOverflow.visible, // Allows text to wrap and show without truncation
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        title: Text(
                                          "Wind:\n${wind}kph",
                                          textAlign: TextAlign.center, // Centers the text
                                          style: TextStyle(color: Colors.black),
                                          softWrap: true, // Ensures text wraps on overflow
                                          overflow: TextOverflow.visible, // Allows text to wrap and show without truncation
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: ListTile(
                                        title: Text(
                                          "Rain:\n${rain}mm",
                                          textAlign: TextAlign.center, // Centers the text
                                          style: TextStyle(color: Colors.black),
                                          softWrap: true, // Ensures text wraps on overflow
                                          overflow: TextOverflow.visible, // Allows text to wrap and show without truncation
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: ListTile(
                                    title: Text(
                                      'Address: $address',
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                      softWrap: true, // Ensures text wraps on overflow
                                      overflow: TextOverflow.visible, // Allows text to wrap and show without truncation
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),



                    // Text(
                    //   'Selected Location:',
                    //   style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    // ),
                    // if (address != null)
                    //   Text(
                    //     'Address: $address',
                    //     style: TextStyle(color: Colors.white70),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // Text("Temp: ${temp}, RH: ${rh}", style: TextStyle(color: textColor),),
                    // Text("Wind: ${wind}, Rain: ${rain}", style: TextStyle(color: textColor),),
                    // Text("Today's Probability of a Fire is",textAlign: TextAlign.center, style: TextStyle(color: textColor),),
                    // Text("${result}", textAlign: TextAlign.center, style: TextStyle(color: textColor),)
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
