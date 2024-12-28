import 'dart:convert';
import 'package:fire_program/model/news.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      duration: Duration(milliseconds: 300),
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
        setState(() {
          imgURL = data['main_image']['url'] ?? "";
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
        title: const Text("Wildfire Data and News"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,)) // Loading indicator
          : imgURL.isNotEmpty
          ? SingleChildScrollView( // Add SingleChildScrollView here
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: buildImage(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Add padding around your news articles to make it look better
            const Padding(
              padding: EdgeInsets.all(7.0),
              child: Column(
                children: [
                  newTemplate(
                      title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                      description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                      imgURL: "assets/news1.png"),
                  newTemplate(
                      title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                      description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                      imgURL: "assets/news1.png"),
                  newTemplate(
                      title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                      description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                      imgURL: "assets/news1.png"),
                  newTemplate(
                      title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                      description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                      imgURL: "assets/news1.png"),
                  newTemplate(
                      title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                      description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                      imgURL: "assets/news1.png"),
                  newTemplate(
                      title: "غرائب التغيرات المناخية.. حرائق غابات استراليا فى الشتاء وتحذيرات بإخلاء المواطنين ",
                      description: "تستمر حرائق الغابات الهائلة التي تزحف عبر إحدى الولايات في تهديد الأرواح والممتلكات في الوقت الذي يستعد فيه رجال الإطفاء لظروف شديدة الحرارة في عيد الميلاد ويوم الملاكمة. ",
                      imgURL: "assets/news1.png"),
                ],
              ),
            ),
          ],
        ),
      )
          : const Center(child: Text("Image not available")), // Error fallback
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
      clipBehavior: Clip.none,
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
