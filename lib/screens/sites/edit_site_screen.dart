import 'package:flutter/material.dart';
import 'package:patromobilelapps/controllers/site_controller.dart'; // Import your site_controller here

class EditSiteScreen extends StatefulWidget {
  final Map<String, dynamic> siteData;

  EditSiteScreen({required this.siteData});

  @override
  _EditSiteScreenState createState() => _EditSiteScreenState();
}

class _EditSiteScreenState extends State<EditSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  SiteController _siteController =
      SiteController(); // Initialize your SiteController

  late TextEditingController _siteIDController;
  late TextEditingController _patrolSiteController;
  late TextEditingController _locationController;
  late TextEditingController _checklistController;

  @override
  void initState() {
    super.initState();
    _siteIDController =
        TextEditingController(text: widget.siteData['SiteID'].toString());
    _patrolSiteController =
        TextEditingController(text: widget.siteData['PatrolSite']);
    _locationController =
        TextEditingController(text: widget.siteData['Location']);
    _checklistController =
        TextEditingController(text: widget.siteData['Checklist']);
  }

  @override
  void dispose() {
    _siteIDController.dispose();
    _patrolSiteController.dispose();
    _locationController.dispose();
    _checklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Site'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _siteIDController,
                decoration: InputDecoration(labelText: 'Site ID'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _patrolSiteController,
                decoration: InputDecoration(labelText: 'Patrol Site'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a patrol site';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _checklistController,
                decoration: InputDecoration(labelText: 'Checklist'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Perform update action
                    // Call the updateSite method from the SiteController
                    // e.g. _siteController.updateSite(siteID: int.parse(_siteIDController.text), patrolSite: _patrolSiteController.text, location: _locationController.text, checklist: _checklistController.text);
                    Navigator.pop(context); // Go back to the index
                  }
                },
                child: Text('Update Site'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
