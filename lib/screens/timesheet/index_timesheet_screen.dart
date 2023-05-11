import 'package:flutter/material.dart';
import 'package:patromobilelapps/utils/api.dart'; // Replace with your actual path
import 'package:patromobilelapps/screens/timesheet/edit_timesheet_screen.dart';
import 'package:patromobilelapps/screens/timesheet/new_timesheet_screen.dart';

class TimesheetScreen extends StatefulWidget {
  @override
  _TimesheetScreenState createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  late List<dynamic> timesheets;
  late Api api;

  @override
  void initState() {
    super.initState();
    api = Api();
    fetchTimesheets();
  }

  Future<void> fetchTimesheets() async {
    await api.fetchBearerToken();
    dynamic fetchedTimesheets = await api.getTimesheets();
    setState(() {
      timesheets = fetchedTimesheets;
    });
  }

  void _navigateToEditTimesheetScreen(
      BuildContext context, Map<String, dynamic> timesheet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTimesheetScreen(timesheet: timesheet),
      ),
    );
  }

  void _navigateToNewTimesheetScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTimesheetScreen()),
    ).then((_) => fetchTimesheets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timesheets'),
      ),
      body: ListView.builder(
        itemCount: timesheets.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Employee ID: ${timesheets[index]['employeeId']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${timesheets[index]['date']}'),
                Text('Clock In Time: ${timesheets[index]['clockInTime']}'),
                Text('Clock Out Time: ${timesheets[index]['clockOutTime']}'),
              ],
            ),
            onTap: () {
              _navigateToEditTimesheetScreen(context, timesheets[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNewTimesheetScreen(context),
        child: Icon(Icons.add),
        tooltip: 'Add New Timesheet',
      ),
    );
  }
}
