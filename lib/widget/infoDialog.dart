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
        "عندما يكون مؤشر الطقس الحرائق منخفضًا، هناك فرصة ضئيلة لاندلاع حريق وغالبًا ما يكون من السهل إطفاؤه. درجات الحرارة الباردة، الرطوبة العالية، الرياح الخفيفة أو العدم، بالإضافة إلى القليل من الأمطار، تجعل من غير المحتمل أن يبدأ حريق، وإذا حدث، يكون من السهل إخماده. لتقليل مؤشر الطقس الحرائق، يوصى باستخدام الطلاءات المنتفخة، المثبطات البورونية، أو المثبطات الهلامية.";

    String medFWI=
        "عندما يكون مؤشر الطقس الحرائق متوسطًا، فإن خطر الحريق معتدل، مع زيادة في خطر الاشتعال والانتشار بسبب درجات الحرارة الدافئة، والرطوبة المعتدلة، والرياح القوية، وفترات الجفاف. الطلاءات المنتفخة، المثبطات الهلامية، والمثبطات التجارية هي الطلاءات المناسبة لتقليل خطر الحريق.";

    String highFWI =
        "عندما يكون مؤشر الطقس الحرائق مرتفعًا، فإن الحريق من المرجح أن يبدأ بسرعة، وينتشر بسرعة، ويصبح خارج عن السيطرة بسبب الطقس الحار، الرطوبة المنخفضة، الرياح القوية، والجفاف الممتد. يوصى باستخدام المثبطات التجارية، المثبطات الهلامية، أو الطلاء المنتفخ لتقليل خطر حدوث حريق.";

    String result = "";
    String bodyText = "";

    Color selectedColor = Colors.white;
    Color low = Colors.green;
    Color med = Colors.orange;
    Color high = Colors.red;

    if (fwi < 5.2) {
      result = "هو خطر منخفض جدًا";
      bodyText = lowFWI;
      selectedColor = low;
    } else if (fwi >= 5.2 && fwi < 11.2) {
      result = "هو خطر منخفض";
      bodyText = lowFWI;
      selectedColor = low;
    } else if (fwi >= 11.2 && fwi < 21.3) {
      result = "هو خطر معتدل";
      bodyText = medFWI;
      selectedColor = med;
    } else if (fwi >= 21.3 && fwi < 38.0) {
      result = "هو خطر كبير";
      bodyText = highFWI;
      selectedColor = high;
    } else if (fwi >= 38.0) {
      result = "هو خطر كبير جدًا";
      bodyText = highFWI;
      selectedColor = high;
    }

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
            const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 80.0,
            ),
            const SizedBox(height: 16),
            Text(
              "مؤشر الطقس الحرائق: $result",
              style: const TextStyle(
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
                    child: const Text(
                      "إغلاق النافذة",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Info())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "مزيد من المعلومات",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
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
