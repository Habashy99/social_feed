import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/providers/auth_providers.dart';
import 'package:social_feed/helpers/providers/user_providers.dart';
import 'package:social_feed/pages/edit_profile.dart';
import 'package:social_feed/pages/login.dart';

class CustomProfile extends HookConsumerWidget {
  final String profilePhoto;
  final String profileName;
  final String profileEmail;
  final String userId;

  const CustomProfile({
    required this.profilePhoto,
    required this.profileName,
    required this.profileEmail,
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          ClipOval(
            child:
                profilePhoto.startsWith("assets/")
                    ? Image.asset(
                      profilePhoto,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                    : Image.file(
                      File(profilePhoto),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              ).then((shouldRefresh) {
                if (shouldRefresh == true) {
                  ref.invalidate(userProvider(userId));
                }
              });
            },
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
          SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              // 1. Clear user from Hive
              await ref.read(logoutProvider.future);
              // 3. Navigate to login page
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Login()),
                (route) => false,
              );
            },
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
            child: Text("Logout", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
