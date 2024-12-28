import 'package:fire_program/services/InputFormat.dart';
import 'package:fire_program/services/fwi_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  final tempText = TextEditingController();
  final rhText = TextEditingController();
  final windText = TextEditingController();
  final rainText = TextEditingController();
  final latText = TextEditingController();

  double tempData = 0.0;
  double rhData = 0.0;
  double windData = 0.0;
  double rainData = 0.0;
  double latData = 0.0;

  FireWeatherIndex fwi = FireWeatherIndex();
  double? FWI;
  String result = "Empty";

  void _setData() {
    setState(() {
      tempData = _parseToDouble(tempText.text.trim());
      rhData = _parseToDouble(rhText.text.trim());
      windData = _parseToDouble(windText.text.trim());
      rainData = _parseToDouble(rainText.text.trim());
      latData = _parseToDouble(latText.text.trim());
      print(tempData);
    });
  }

  double _parseToDouble(String input) {
    final parsedValue = num.tryParse(input); // Try parsing as num (can handle both int and double)
    return parsedValue?.toDouble() ?? 0.0; // Convert to double or default to 0.0
  }

  Widget buildInputField(String label, TextEditingController controller, String description) {
    bool isDescriptionVisible = false; // Local state for toggling description

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Adjusted for better visibility
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isDescriptionVisible ? Icons.info : Icons.info_outline,
                      color: Colors.orange, // Info icon color
                    ),
                    onPressed: () {
                      setState(() {
                        isDescriptionVisible = !isDescriptionVisible; // Toggle description visibility
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  InputFormat(),
                ],
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12, // Darker background color
                  border: InputBorder.none, // Remove border
                  enabledBorder: InputBorder.none, // Remove border when enabled
                  focusedBorder: InputBorder.none, // Remove border when focused
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: isDescriptionVisible,
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fire Calculator"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInputField(
                  "Temperature",
                  tempText,
                  "Temperature in Degrees Celsius is used in calculating the Fine Fuel Moisture Code (FFMC), Duff Moisture Code (DMC) and Drought Code (DC)",
                ),
                buildInputField(
                  "Humidity",
                  rhText,
                  "Humidity in Percentage is the measure of water vapour in the air and is used in Fine Fuel Moisture Code (FFMC) and Duff Moisture Code (DMC)",
                ),
                buildInputField(
                  "Wind",
                  windText,
                  "Wind Speed in kph is used in Fine Fuel Moisture Code (FFMC) and Initial Spread Index (ISI)",
                ),
                buildInputField(
                  "Rain",
                  rainText,
                  "Accumulated rainfall in mm as known as Precipitation is used for Fine Fuel Moisture Code (FFMC), Duff Moisture Code (DMC) and Drought Code (DC)",
                ),
                buildInputField(
                  "Latitude",
                  latText,
                  "Latitude in decimal degrees of the location for which calculations are being made and used for Duff Moisture Code (DMC) and Drought Code (DC)",
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "The Probability of a Fire is $result",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.orangeAccent.withOpacity(0.8);
                              } else if (states.contains(MaterialState.pressed)) {
                                return Colors.deepOrange;
                              }
                              return Colors.orange;
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.orangeAccent.withOpacity(0.2),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 50),
                          ),
                          elevation: MaterialStateProperty.resolveWith<double>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return 6;
                              }
                              return 3;
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _setData();
                            FWI = fwi.calcFWI(tempData, rhData, windData, rainData, latData);
                            print(FWI);
                            if (FWI! < 5.2) {
                              result = "Very Low Danger";
                            } else if (FWI! >= 5.2 && FWI! < 11.2) {
                              result = "Low Danger";
                            } else if (FWI! >= 11.2 && FWI! < 21.3) {
                              result = "Moderate Danger";
                            } else if (FWI! >= 21.3 && FWI! < 38.0) {
                              result = "High Danger";
                            } else if (FWI! >= 38.0) {
                              result = "Very High Danger";
                            }
                          });
                        },
                        child: const Text(
                          'CALCULATE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
