// ignore: unused_import
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Future<void> showDeleteDialog(BuildContext context, String userId) async {
  final parentContext = context; // Save the parent context
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          'confirm_delete_account'.tr(),
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'are_you_sure_delete'.tr(),
          style: GoogleFonts.poppins(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('no'.tr(),
                style: GoogleFonts.poppins(
                    color: const Color.fromRGBO(255, 235, 59, 0.8))),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text('yes'.tr(), style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () async {
              try {
                Navigator.of(dialogContext).pop();
                // Use parentContext for navigation!
                await deleteUserProfile(parentContext, userId);
              } catch (e) {
                print('failed_delete_profile $e'.tr());
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> deleteUserProfile(BuildContext context, String userId) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('deleting_profile_wait'.tr())),
    );

    final userResponse = await http.get(
        Uri.parse("https://dearoagro-backend.onrender.com/api/buyers/$userId"));

    if (userResponse.statusCode != 200) {
      print("Failed to fetch user info: ${userResponse.body}");
      throw Exception("Failed to get user type");
    }

    final userData = jsonDecode(userResponse.body);
    final userType = userData['userType'];

    if (userType == null) {
      throw Exception("User type is null or invalid");
    }

    await http.delete(
        Uri.parse("https://dearoagro-backend.onrender.com/api/buyers/$userId"));

    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('profile_deleted_success'.tr())),
    );
    await Future.delayed(const Duration(milliseconds: 300));
    Navigator.pushNamedAndRemoveUntil(context, "/signUp", (route) => false);
  } catch (e) {
    print('failed_delete_profile'.tr());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('error: ${e.toString()}'.tr())),
    );
  }
}
