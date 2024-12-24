
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
  final tempText=TextEditingController();
  final rhText=TextEditingController();
  final windText=TextEditingController();
  final rainText=TextEditingController();
  final latText=TextEditingController();

  double tempData=0.0;
  double rhData=0.0;
  double windData=0.0;
  double rainData=0.0;
  double latData=0.0;



  FireWeatherIndex fwi=new FireWeatherIndex();
  double? FWI;
  String result="Empty";

  void _setData(){
    setState(() {
      if(tempText.text.isNotEmpty){
        tempData=double.parse(tempText.text.trim());
      } else if(tempText.text.isEmpty){
        tempData=0.0;
      }
      if(rhText.text.isNotEmpty){
        rhData=double.parse(rhText.text.trim());
      } else if(rhText.text.isEmpty){
        rhData=0.0;
      }
      if(windText.text.isNotEmpty){
        windData=double.parse(windText.text.trim());
      } else if(windText.text.isEmpty){
        windData=0.0;
      }
      if(rainText.text.isNotEmpty){
        rainData=double.parse(rainText.text.trim());
      } else if(rainText.text.isEmpty){
        rainData=0.0;
      }
      if(latText.text.isNotEmpty){
        latData=double.parse(latText.text.trim());
      } else if(latText.text.isEmpty){
        latData=0.0;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fire Calculator"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns columns at the top
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Aligns child elements
                      children: [
                        const Text(
                          "Temperature",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 150, // Set a fixed width for the TextField
                          child: TextField(
                            controller: tempText,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                              InputFormat(),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Temperature in Degrees Celsius is used in calculating the Fine Fuel Moisture Code (FFMC), Duff Moisture Code (DMC) and Drought Code (DC)",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Aligns child elements
                      children: [
                        const Text(
                          "Humidity",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 150, // Set a fixed width for the TextField
                          child: TextField(
                            controller: rhText,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                              InputFormat(),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Humidity in Percentage is the measure of water vapour in the air and is used in Fine Fuel Moisture Code (FFMC) and Duff Moisture Code (DMC)",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns columns at the top
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Aligns child elements
                      children: [
                        const Text(
                          "Wind",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 150, // Set a fixed width for the TextField
                          child: TextField(
                            controller: windText,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                              InputFormat(),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Wind Speed in kph is used in Fine Fuel Moisture Code (FFMC) and Initial Spread Index (ISI)",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Aligns child elements
                      children: [
                        const Text(
                          "Rain",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 150, // Set a fixed width for the TextField
                          child: TextField(
                            controller: rainText,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                              InputFormat(),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Accumulated rainfall in mm as known as Precipitation is used for Fine Fuel Moisture Code (FFMC), Duff Moisture Code (DMC) and Drought Code (DC)",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Latitude",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 150, // Set a fixed width for the TextField
                          child: TextField(
                            controller: latText,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                              InputFormat(),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Latitude in decimal degrees of the location for which calculations are being made and used for Duff Moisture Code (DMC) and Drought Code (DC)",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("The Probability of a Fire is ${result}"),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return Colors.orange.withOpacity(0.04);
                              }
                              if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
                                return Colors.orange.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                          side: WidgetStateProperty.resolveWith<BorderSide>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered) ||
                                  states.contains(WidgetState.focused) ||
                                  states.contains(WidgetState.pressed)) {
                                return BorderSide(color: Colors.orange, width: 2); // Change border when interacting
                              }
                              return BorderSide(color: Colors.black, width: 0.7); // Default border
                            },
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
                          ),
                        ),

                        onPressed: () {
                          _setData();
                          FWI=fwi.calcFWI(tempData, rhData, windData, rainData, latData);
                          if(FWI!<5.2){
                            result="Very Low Danger";
                          } else if(FWI!>=5.2&&FWI!<11.2){
                            result="Low Danger";
                          } else if(FWI!>=11.2&&FWI!<21.3){
                            result="Moderate Danger";
                          } else if(FWI!>=21.3&&FWI!<38.0){
                            result="High Danger";
                          } else if(FWI!>=38.0){
                            result="Very High Danger";
                          }
                        },
                        child: Text('CALCULATE')
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
