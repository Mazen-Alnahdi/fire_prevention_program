import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/news.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  String imgURL = "";
  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  bool isLoading = true;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    fetchFWIHeatMap(); // Fetch image URL during initialization
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      controller.value = animation!.value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<void> fetchFWIHeatMap() async {
    try {
      final url = Uri.parse('https://svs.gsfc.nasa.gov/api/5315');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final imageUrl = data['main_image']['url'] ?? "";

        // Use a CORS proxy to fetch the image
        final proxyUrl = 'https://cors-anywhere.herokuapp.com/$imageUrl';

        setState(() {
          imgURL = proxyUrl;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بيانات الحرائق والأخبار"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,)) // Loading indicator
          : imgURL.isNotEmpty
          ? Stack(
        children: [
          // Scrollable content for news articles
          const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 220.0),  // Padding to make space for the image
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Column(
                      children: [
                        newTemplate(
                            title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                            description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                            imgURL: "assets/news1.png"),
                        newTemplate(
                            title: " أستراليا تحث المئات على الفرار من حرائق الغابات غرب ولاية '"'فيكتوريا"'"",
                            description:"                            أصدرت السلطات الأسترالية، اليوم  السبت أمرًا بالإخلاء لمئات السكان في غرب ولاية فيكتوريا؛ بعد أن خرجت حرائق الغابات في الولاية عن نطاق السيطرة.",
                            imgURL: "assets/news2.png"),
                        newTemplate(
                            title: "                            حرائق الغابات فى 2024.. 6 قتلى ونفوق أكثر من 44 ألف حيوان بالإكوادور",
                            description: "                            تسببت حرائق الغابات المدمرة التي دمرت الغابات والمحاصيل في الإكوادور في عام 2024 في مصرع 6 أشخاص، في المقاطعات مثل سانتا إيلينا وإل أورو، والأخيرة هي رابع أكثر المقاطعات تضرراً. ",
                            imgURL: "assets/news4.png"),
                        newTemplate(
                            title: "حرائق الغابات 2024.. تسجيل أكثر من 50 ألف حريق.. نزوح الآلاف في كاليفورنيا.. بوليفيا تعاني من أكبر أزمة بيئية.. دراسة: وفاة أكثر من مليون شخص بسبب الدخان.. ودمار 79 ألف هكتار من الغطاء النباتى ",
                            description: "                            اندلعت عدة حرائق الغابات في العالم منذ بداية 2024، وذلك بسبب ارتفاع درجات الحرارة و الجفاف الشديد التي مر بها العديد من الدول. ",
                            imgURL: "assets/news3.png"),
                        SizedBox(height: 60,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed image at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: buildImage(),  // Image fixed at the top
          ),
        ],
      )
          : const Center(child: Text("الصورة غير متوفرة")), // Error fallback
    );
  }

  Widget buildImage() => GestureDetector(
    onDoubleTapDown: (details) => tapDownDetails = details,
    onDoubleTap: () {
      final position = tapDownDetails!.localPosition;
      const double scale = 5; // Zoom scale factor

      final x = -position.dx * (scale - 1);
      final y = -position.dy * (scale - 1);

      final zoomed = Matrix4.identity()
        ..translate(x, y)
        ..scale(scale);

      // Toggle between zoomed-in and zoomed-out states
      final isZoomedIn = !controller.value.isIdentity();
      final end = isZoomedIn ? Matrix4.identity() : zoomed;

      // Create the zoom animation based on current state
      animation = Matrix4Tween(
        begin: controller.value,
        end: end,
      ).animate(
        CurveTween(curve: Curves.easeOut).animate(animationController),
      );

      animationController.forward(from: 0);
    },
    child: InteractiveViewer(
      transformationController: controller,
      clipBehavior: Clip.none, // Prevent clipping of the image when zoomed
      panEnabled: true, // Allow panning
      scaleEnabled: true, // Allow scaling (pinch-to-zoom)
      minScale: 1.0, // Minimum zoom scale
      maxScale: 5.0, // Maximum zoom scale
      child: AspectRatio(
        aspectRatio: 2,
        child: Image.network(
          imgURL,
          fit: BoxFit.fitWidth,
        ),
      ),
    ),
  );
}
