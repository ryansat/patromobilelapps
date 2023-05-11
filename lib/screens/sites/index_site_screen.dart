import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:patromobilelapps/screens/sites/edit_site_screen.dart';

class ViewSiteScreen extends StatefulWidget {
  final String sitesJson;

  ViewSiteScreen({required this.sitesJson});

  @override
  _ViewSiteScreenState createState() => _ViewSiteScreenState();
}

class _ViewSiteScreenState extends State<ViewSiteScreen> {
  late List<dynamic> sites;

  @override
  void initState() {
    super.initState();
    sites = json.decode(widget.sitesJson);
  }

  void _navigateToEditSiteScreen(
      BuildContext context, Map<String, dynamic> siteData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSiteScreen(siteData: siteData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Site List')),
      body: ListView.builder(
        itemCount: sites.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(sites[index]['PatrolSite']),
            subtitle: Text(sites[index]['Location']),
            onTap: () {
              _navigateToEditSiteScreen(context, sites[index]);
            },
          );
        },
      ),
    );
  }
}
