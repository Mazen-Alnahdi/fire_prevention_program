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
        title: const Text("حاسبة النار"),
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
                  "درجة حرارة",
                  tempText,
                  "تُستخدم درجة الحرارة بالدرجات المئوية في حساب كود رطوبة الوقود الدقيق، وكود رطوبة داف، وكود الجفاف",
                ),
                buildInputField(
                  "رطوبة",
                  rhText,
                  "الرطوبة بالنسبة المئوية هي مقياس لبخار الماء في الهواء وتستخدم في رمز رطوبة الوقود الدقيق ورمز رطوبة داف",
                ),
                buildInputField(
                  "رياح",
                  windText,
                  "يتم استخدام سرعة الرياح بالكيلومتر في الساعة في كود رطوبة الوقود الدقيق ومؤشر الانتشار الأولي",
                ),
                buildInputField(
                  "مطر",
                  rainText,
                  "يتم استخدام هطول الأمطار المتراكم بالملليمتر والمعروف باسم هطول الأمطار في كود رطوبة الوقود الدقيق، ورمز رطوبة داف، ورمز الجفاف",
                ),
                buildInputField(
                  "خط العرض",
                  latText,
                  "خط العرض بالدرجات العشرية للموقع الذي يتم إجراء الحسابات له واستخدامه في رمز رطوبة داف وكود الجفاف",
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "احتمال الحريق هو $result",
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
                              result = "خطر منخفض جدًا";
                            } else if (FWI! >= 5.2 && FWI! < 11.2) {
                              result = "خطر منخفض";
                            } else if (FWI! >= 11.2 && FWI! < 21.3) {
                              result = "خطر معتدل";
                            } else if (FWI! >= 21.3 && FWI! < 38.0) {
                              result = "خطر كبير";
                            } else if (FWI! >= 38.0) {
                              result = "خطر كبير جدًا";
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
