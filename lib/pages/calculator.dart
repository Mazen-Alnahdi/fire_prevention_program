import 'package:fire_program/services/AltInputFormat.dart';
import 'package:fire_program/services/InputFormat.dart';
import 'package:fire_program/services/fwi_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/infoDialog.dart';
import 'info.dart';

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
  String result = "";
  bool isDescriptionVisible = false;

  void _setData() {
    setState(() {
      tempData = _parseToDouble(tempText.text.trim());
      rhData = _parseToDouble(rhText.text.trim());
      windData = _parseToDouble(windText.text.trim());
      rainData = _parseToDouble(rainText.text.trim());
      latData = _parseToDouble(latText.text.trim());
    });
  }

  double _parseToDouble(String input) {
    final parsedValue = num.tryParse(input); // Try parsing as num (can handle both int and double)
    return parsedValue?.toDouble() ?? 0.0; // Convert to double or default to 0.0
  }

  Widget buildInputField(
      String label,
      TextEditingController controller,
      String description,
      String helper,
      double min,
      double max,
      bool negative) {
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
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      // Adjusted for better visibility
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                inputFormatters: [
                  // FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  InputFormat(min:min,max: max, negative:negative),
                ],
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: negative),
                decoration: InputDecoration(
                  helper:  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      helper,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
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
    return Scaffold(
      appBar: AppBar(
        // Fire Weather Index
        title: const Text("حاسبة الحريق"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Info())
                );
              },
              icon: const Icon(Icons.info_outline)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          const Text(
                            // Temperature
                            "درجة الحرارة (\u00b0C )",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              // Adjusted for better visibility
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: tempText,
                        inputFormatters: [
                          AltInputFormat(),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(
                          helper:  Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '-100 إلى 100',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
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
                        child: const Text(
                          "تُستخدم درجة الحرارة بالدرجات المئوية في حساب كود رطوبة الوقود الدقيق، وكود رطوبة داف، وكود الجفاف",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                buildInputField(
                  // Humidity
                    "(%) الرطوبة",
                    rhText,
                    "الرطوبة بالنسبة المئوية هي مقياس لبخار الماء في الهواء وتستخدم في رمز رطوبة الوقود الدقيق ورمز رطوبة داف",
                    "0-100",
                    0,
                    100,
                    false
                ),
                buildInputField(
                  // Wind
                    "(kph) الرياح",
                    windText,
                    "يتم استخدام سرعة الرياح بالكيلومتر في الساعة في كود رطوبة الوقود الدقيق ومؤشر الانتشار الأولي",
                    "0-118",
                    0,
                    118,
                    false
                ),
                buildInputField(
                  // Rain / Precipitation
                    "(mm) الأمطار",
                    rainText,
                    "يتم استخدام هطول الأمطار المتراكم بالملليمتر والمعروف باسم هطول الأمطار في كود رطوبة الوقود الدقيق، ورمز رطوبة داف، ورمز الجفاف",
                    "0-100",
                    0,
                    100,
                    false
                ),
                buildInputField(
                  // Latitude
                    "خط العرض (\u00b0)",
                    latText,
                    "خط العرض بالدرجات العشرية للموقع الذي يتم إجراء الحسابات له واستخدامه في رمز رطوبة داف وكود الجفاف",
                    "-90 إلى 90",
                    -90,
                    90,
                    true
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // Fire Weather Index
                      "احتمال الحريق $result",
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
                    SizedBox(width: 10,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.orangeAccent.withOpacity(0.8);
                                } else if (states.contains(WidgetState.pressed)) {
                                  return Colors.deepOrange;
                                }
                                return Colors.orange;
                              },
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            overlayColor: WidgetStateProperty.all<Color>(
                              Colors.orangeAccent.withOpacity(0.2),
                            ),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            ),
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size(200, 50),
                            ),
                            elevation: WidgetStateProperty.resolveWith<double>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
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
                              if (FWI! < 5.2) {
                                result = "هو خطر منخفض جدًا";
                              } else if (FWI! >= 5.2 && FWI! < 11.2) {
                                result = "هو خطر منخفض";
                              } else if (FWI! >= 11.2 && FWI! < 21.3) {
                                result = "هو خطر معتدل";
                              } else if (FWI! >= 21.3 && FWI! < 38.0) {
                                result = "هو خطر كبير";
                              } else if (FWI! >= 38.0) {
                                result = "هو خطر كبير جدًا";
                              }
                            });
                          },
                          child: const Text(
                            'الحساب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.orangeAccent.withOpacity(0.8);
                                } else if (states.contains(WidgetState.pressed)) {
                                  return Colors.deepOrange;
                                }
                                return Colors.orange;
                              },
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            overlayColor: WidgetStateProperty.all<Color>(
                              Colors.orangeAccent.withOpacity(0.2),
                            ),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            ),
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size(200, 50),
                            ),
                            elevation: WidgetStateProperty.resolveWith<double>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return 6;
                                }
                                return 3;
                              },
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return InfoDialog(fwi: FWI ?? 0.0);
                                });
                          },
                          child: const Text(
                            'عرض المعلومات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
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
