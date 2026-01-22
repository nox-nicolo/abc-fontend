
import 'package:flutter/material.dart';

class PostTextInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool hasImages;

  const PostTextInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hasImages,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: hasImages ? 2 : 3,
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        onChanged: (text) => onChanged(),
        decoration: InputDecoration(
          hintText: 'What\'s on your mind?',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          height: 1.4,
        ),
      ),
    );
  }
}
