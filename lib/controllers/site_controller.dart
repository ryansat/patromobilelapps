import 'package:flutter/widgets.dart';
import '../utils/api.dart';

class SiteController with ChangeNotifier {
  final Api api = Api();

  void setBearerToken(String token) {
    api.setBearerToken(token);
  }

  Future<dynamic> getSites() async {
    return await api.getSites();
  }

  Future<dynamic> addSite(Map<String, String> siteData) async {
    return await api.addSite(siteData);
  }

  Future<dynamic> updateSite(int siteId, Map<String, String> siteData) async {
    return await api.updateSite(siteId, siteData);
  }
}
