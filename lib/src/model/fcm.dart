import 'dart:io';

class FcmModel {
  final String _id;

  FcmModel(id): _id = id;

  String id() => _id;

  Map<String, dynamic> toMap() {
    String operatingSystem = Platform.operatingSystem;
    String operatingSystemVersion = Platform.operatingSystemVersion;
    String localeName = Platform.localeName;

    return <String, dynamic>{
      'fcm': _id,
      'date': DateTime.now().toIso8601String(),
      'operatingSystem': operatingSystem,
      'operatingSystemVersion': operatingSystemVersion,
      'localeName': localeName,
    };
  }
}