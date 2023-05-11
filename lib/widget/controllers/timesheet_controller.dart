import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patromobilelapps/utils/api.dart';
import 'package:intl/intl.dart';

class TimesheetController {
  Api _api = Api();

  void setBearerToken(String token) {
    _api.setBearerToken(token);
  }

  Future<dynamic> getTimesheets() async {
    return await _api.getTimesheets();
  }

  Future<dynamic> createTimesheets(FormData) async {
    return await _api.createTimesheet(FormData);
  }
}
