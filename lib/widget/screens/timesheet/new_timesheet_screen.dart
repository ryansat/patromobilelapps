import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:patromobilelapps/controllers/timesheet_controller.dart';
import 'package:patromobilelapps/screens/timesheet/index_timesheet_screen.dart';

class NewTimesheetScreen extends StatefulWidget {
  @override
  _NewTimesheetScreenState createState() => _NewTimesheetScreenState();
}

class _NewTimesheetScreenState extends State<NewTimesheetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TimesheetController _timesheetController = TimesheetController();
  late TextEditingController _employeeIdController;
  late TextEditingController _dateController;
  late TextEditingController _clockInTimeController;
  late TextEditingController _clockOutTimeController;
  File? _checkInPhoto;
  File? _checkOutPhoto;

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController();
    _dateController =
        TextEditingController(text: DateTime.now().toString().substring(0, 10));
    _clockInTimeController = TextEditingController();
    _clockOutTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _dateController.dispose();
    _clockInTimeController.dispose();
    _clockOutTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (type == 'checkIn') {
        setState(() {
          _checkInPhoto = file;
        });
      } else if (type == 'checkOut') {
        setState(() {
          _checkOutPhoto = file;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Get the base64-encoded strings of the images (if they exist)
        String? checkInPhoto = _checkInPhoto != null
            ? base64Encode(_checkInPhoto!.readAsBytesSync())
            : null;
        String? checkOutPhoto = _checkOutPhoto != null
            ? base64Encode(_checkOutPhoto!.readAsBytesSync())
            : null;

        // Create a map of the form data
        Map<String, dynamic> formData = {
          'employeeId': _employeeIdController.text,
          'date': _dateController.text,
          'clockInTime': _clockInTimeController.text,
          'clockOutTime': _clockOutTimeController.text,
        };

        // Add the photo data to the form data (if it exists)
        if (checkInPhoto != null) {
          formData['checkInPhoto'] = checkInPhoto;
        }
        if (checkOutPhoto != null) {
          formData['checkOutPhoto'] = checkOutPhoto;
        }

        // Make the API request
        await _timesheetController.createTimesheets(formData);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimesheetScreen()),
        );
      } catch (e) {
        print('Error creating timesheet: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create timesheet.'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Timesheet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _employeeIdController,
                decoration: InputDecoration(labelText: 'Employee ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an employee ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2023),
                  );
                  if (date != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clockInTimeController,
                decoration: InputDecoration(labelText: 'Clock In Time'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (time != null) {
                    _clockInTimeController.text = time.format(context);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a clock in time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clockOutTimeController,
                decoration: InputDecoration(labelText: 'Clock Out Time'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (time != null) {
                    _clockOutTimeController.text = time.format(context);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a clock out time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _checkInPhoto == null
                        ? ElevatedButton.icon(
                            onPressed: () {
                              _pickImage('checkIn');
                            },
                            icon: Icon(Icons.camera_alt),
                            label: Text('Check In Photo'),
                          )
                        : Image.memory(_checkInPhoto!.readAsBytesSync()),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _checkOutPhoto == null
                        ? ElevatedButton.icon(
                            onPressed: () {
                              _pickImage('checkOut');
                            },
                            icon: Icon(Icons.camera_alt),
                            label: Text('Check Out Photo'),
                          )
                        : Image.memory(_checkOutPhoto!.readAsBytesSync()),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
