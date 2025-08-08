import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomProfile extends HookWidget {
  final String profilePhoto;
  final String profileName;
  final String profileEmail;

  const CustomProfile({
    required this.profilePhoto,
    required this.profileName,
    required this.profileEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              profilePhoto,
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            profileName,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(profileEmail, style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 220, 220, 220),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              padding: WidgetStateProperty.all(
                EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              ),
            ),
            child: Text("Edit Profile", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
