import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenFullImage extends StatelessWidget {
  final Uint8List imageBytes;
  final int index;
  final VoidCallback onDelete; 

  const ScreenFullImage({
    super.key,
    required this.imageBytes,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var imageBox = Hive.box('imageBox');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text('Full Screen Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to delete this image?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        imageBox.deleteAt(index);
                        onDelete();
                        Navigator.pop(context); // Close the confirmation dialog
                        Navigator.pop(context); // Close the image screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Image deleted successfully!'),
                          ),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Image.memory(
          imageBytes,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
