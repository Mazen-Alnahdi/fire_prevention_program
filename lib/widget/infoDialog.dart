import 'package:flutter/material.dart';

import '../pages/info.dart';

class InfoDialog extends StatelessWidget {
  final double fwi;

  const InfoDialog({
    super.key,
    required this.fwi,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width as 80% of the screen width
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;

    String lowFWI =
        "When the Fire Weather Index is low, there is little chance that a wildfire will start and spread. Cool temperatures, high humidity, little to no wind, and little precipitation make it extremely unlikely for a fire to start and, if it does, easy to put out. To reduce the fire weather index and the likelihood of a wildfire, it is advised to apply Intumescent Coatings, Boron Retardants, or Gel Retardants. ";

    String medFWI=
        "The Fire weather index is medium, indicating that the fire risk is moderate, with an increased risk of ignition and spread due to warmer temperatures, moderate humidity, stronger winds, and drying periods. Intumescet coating, gel retardants, and commercial retardants are all appropriate coatings to use to reduce the risk of fire. ";

    String highFWI =
        "With a high fire weather index, the fire is more likely to start, spread quickly, and become uncontrollable because of the hot weather, low humidity, strong winds, and extended dryness. Using commercial retardants, gel retardants, or intumescent coating is advised to lessen the chance of a wildfire in the area.";
    String result = "";
    String bodyText="";

    Color selectedColor= Colors.white;
    Color low=Colors.green;
    Color med=Colors.orange;
    Color high=Colors.red;


    if (fwi < 5.2) {
      result = "هو خطر منخفض جدًا";
      bodyText=lowFWI;
      selectedColor=low;
    } else if (fwi >= 5.2 && fwi < 11.2) {
      result = "هو خطر منخفض";
      bodyText=lowFWI;
      selectedColor=low;
    } else if (fwi >= 11.2 && fwi < 21.3) {
      result = "هو خطر معتدل";
      bodyText=medFWI;
      selectedColor=med;
    } else if (fwi >= 21.3 && fwi < 38.0) {
      result = "هو خطر كبير";
      bodyText=highFWI;
      selectedColor=high;
    } else if (fwi >= 38.0) {
      result = "هو خطر كبير جدًا";
      bodyText=highFWI;
      selectedColor=high;
    }


    // return Dialog(
    //   alignment: Alignment.center,
    //   insetPadding: const EdgeInsets.all(2.0),
    //   child: Container(
    //     width: dialogWidth, // Set the width dynamically
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       // Ensure the column adjusts to its content
    //       children: [
    //         // Add your dialog content here
    //         Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text(
    //             'Fire Weather Index: $fwi',
    //             style: const TextStyle(fontSize: 18),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text(
    //             bodyText,
    //             style: const TextStyle(fontSize: 18),
    //           ),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //           },
    //           child: const Text('Close'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );


    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 80.0,
            ),
            const SizedBox(height: 16),
            Text(
              "Fire Weather Index ${result}",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              bodyText,
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Close Window",
                      style: const TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>Info())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "More Info",
                      style: const TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
