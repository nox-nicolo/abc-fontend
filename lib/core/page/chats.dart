import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual chat count
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/dp.jpg'), // Replace with actual image
            ),
            title: Text('User $index'),
            subtitle: Text('Last message $index'),
            trailing: const Text('10:00 AM'), // Replace with actual time
          );
        },
      ),
    );
  }
}