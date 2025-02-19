import 'package:flutter/material.dart';

class newTemplate extends StatelessWidget {
  final String title;
  final String description;
  final String imgURL;

  const newTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.imgURL,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange, // Set the background color to orange
          borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Adjust alignment if needed
          children: [
            // Image should have a constrained width (take full width of screen)
            Center(
              child: Image.asset(
                imgURL,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width, // Make sure the image fits within the screen
                height: 200, // Set a fixed height or adjust as needed
              ),
            ),
            const SizedBox(height: 16),
            // Title text
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Ensure text is visible on orange background
              ),
              textAlign: TextAlign.end, // Align text to the start
              maxLines: 2, // Optional: Limit title to two lines
              overflow: TextOverflow.ellipsis, // Optional: Add ellipsis if text overflows
            ),
            const SizedBox(height: 8),
            // Description text
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // Ensure text is visible on orange background
              ),
              textAlign: TextAlign.end, // Align text to the start
              maxLines: 3, // Optional: Limit description to three lines
              overflow: TextOverflow.ellipsis, // Optional: Add ellipsis if text overflows
            ),
          ],
        ),
      ),
    );
  }
}
