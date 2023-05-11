import 'package:flutter/material.dart';
import 'package:patromobilelapps/utils/api.dart'; // Replace with your actual path

class EditTimesheetScreen extends StatefulWidget {
  final Map<String, dynamic> timesheet;

  EditTimesheetScreen({required this.timesheet});

  @override
  _EditTimesheetScreenState createState() => _EditTimesheetScreenState();
}

class _EditTimesheetScreenState extends State<EditTimesheetScreen> {
  final _formKey = GlobalKey<FormState>();
  late Api api;

  late TextEditingController _employeeIdController;
  late TextEditingController _dateController;
  late TextEditingController _clockInTimeController;
  late TextEditingController _clockOutTimeController;

  @override
  void initState() {
    super.initState();
    api = Api();
    _employeeIdController =
        TextEditingController(text: widget.timesheet['employeeId'].toString());
    _dateController = TextEditingController(text: widget.timesheet['date']);
    _clockInTimeController =
        TextEditingController(text: widget.timesheet['clockInTime']);
    _clockOutTimeController =
        TextEditingController(text: widget.timesheet['clockOutTime']);
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _dateController.dispose();
    _clockInTimeController.dispose();
    _clockOutTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Timesheet'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _employeeIdController,
                decoration: InputDecoration(labelText: 'Employee ID'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clockInTimeController,
                decoration: InputDecoration(labelText: 'Clock In Time'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a clock in time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clockOutTimeController,
                decoration: InputDecoration(labelText: 'Clock Out Time'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a clock out time';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Perform update action
                    // Call the updateTimesheet method from the Api class
                    Map<String, String> timesheetData = {
                      'employeeId': _employeeIdController.text,
                      'date': _dateController.text,
                      'clockInTime': _clockInTimeController.text,
                      'clockOutTime': _clockOutTimeController.text,
                    };

                    int timesheetId = widget.timesheet['id'];
                    await api.updateTimesheet(timesheetId, timesheetData);
                    Navigator.pop(context); // Go back to the timesheets index
                  }
                },
                child: Text('Update Timesheet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
