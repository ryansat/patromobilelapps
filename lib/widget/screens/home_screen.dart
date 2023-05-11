import 'package:flutter/material.dart';
import 'package:patromobilelapps/screens/timesheet/edit_timesheet_screen.dart';
// import 'package:my_app/screens/screen2.dart';
// import 'package:my_app/screens/screen3.dart';
// import 'package:my_app/screens/screen4.dart';
import 'package:patromobilelapps/controllers/navigation_controller.dart';

class HomeScreen extends StatelessWidget {
  final NavigationController navigationController = NavigationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrahaSatria Technology'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => navigationController.navigateToScreen1(context),
              child: const Text('Daftar Titik Patrol'),
            ),
            ElevatedButton(
              onPressed: () => navigationController.navigateToScreen2(context),
              child: const Text('Laporan Patrol'),
            ),
            ElevatedButton(
              onPressed: () => navigationController.navigateToScreen3(context),
              child: const Text('Pengaturan'),
            ),
            ElevatedButton(
              onPressed: () => navigationController.navigateToScreen4(context),
              child: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}
