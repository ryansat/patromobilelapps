import 'package:patromobilelapps/utils/api.dart';

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
