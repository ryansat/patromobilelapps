import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patromobilelapps/screens/timesheet/index_timesheet_screen.dart';
import 'package:patromobilelapps/screens/sites/index_site_screen.dart';
import 'package:patromobilelapps/utils/api.dart'; // Import your utils/api.dart

// import 'package:my_app/screens/screen2.dart';
// import 'package:my_app/screens/screen3.dart';
// import 'package:my_app/screens/screen4.dart';

class NavigationController {
  void navigateToScreen1(BuildContext context) async {
    try {
      Api api = Api();
      await api.fetchBearerToken();
      dynamic sites = await api.getSites(); // Call the getSites function
      String sitesJson =
          jsonEncode(sites); // Convert the result to a JSON string
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewSiteScreen(
            sitesJson: sitesJson,
          ),
        ),
      );
    } catch (e) {
      // Handle error here, e.g., show a SnackBar or AlertDialog with the error message
      print('Failed to fetch sites: $e');
    }
  }

  void navigateToScreen2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimesheetScreen()),
    );
  }

  void navigateToScreen3(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Screen3()),
    // );
  }

  void navigateToScreen4(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Screen4()),
    // );
  }
}
