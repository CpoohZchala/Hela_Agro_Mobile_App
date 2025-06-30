import 'package:easy_localization/easy_localization.dart';
import 'package:farmeragriapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> logoutUser(BuildContext context) async {
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('logged_out_success'.tr())),
  );
  await AuthService.clearAuthData();
  Navigator.pushReplacementNamed(context, '/signIn');
}


Future<void> showLogOutDialog(BuildContext context, String userId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'confirm_logout'.tr(),
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'are_you_sure_logout'.tr(),
          style: GoogleFonts.poppins(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('cancel'.tr(), style: GoogleFonts.poppins(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('logout'.tr(), style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () async {
              Navigator.of(context).pop(); 
              await logoutUser(context); 
            },
          ),
        ],
      );
    },
  );
}
