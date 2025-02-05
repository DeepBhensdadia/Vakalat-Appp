import 'dart:convert';

import 'package:dio/dio.dart';

PersonalDetailsModel personalDetailsModelFromJson(String str) =>
    PersonalDetailsModel.fromJson(json.decode(str));

String personalDetailsModelToJson(PersonalDetailsModel data) =>
    json.encode(data.toJson());

class PersonalDetailsModel {
  PersonalDetailsModel({
    required this.apiKey,
    required this.device,
    required this.accessToken,
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.shortName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.isPhysicalChal,
    required this.isPhysicaldet,
    this.videoProfile,
    required this.organization,
    required this.since,
    required this.logo,
    this.profile,
  });

  String? apiKey;
  String? device;
  String? accessToken;
  String? userId;
  String? firstName;
  String? middleName;
  String? shortName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? bloodGroup;
  String? isPhysicalChal;
  String? isPhysicaldet;
  dynamic videoProfile;
  String? organization;
  String? since;
  String? logo;
  dynamic profile;

  PersonalDetailsModel copyWith({
    String? apiKey,
    String? device,
    String? accessToken,
    String? userId,
    String? firstName,
    String? middleName,
    String? shortName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? isPhysicalChal,
    String? isPhysicaldet,
    dynamic videoProfile,
    String? organization,
    String? since,
    String? logo,
    dynamic profile,
  }) =>
      PersonalDetailsModel(
        apiKey: apiKey ?? this.apiKey,
        device: device ?? this.device,
        accessToken: accessToken ?? this.accessToken,
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        shortName: shortName ?? this.shortName,
        lastName: lastName ?? this.lastName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        isPhysicalChal: isPhysicalChal ?? this.isPhysicalChal,
        isPhysicaldet: isPhysicaldet ?? this.isPhysicaldet,
        videoProfile: videoProfile ?? this.videoProfile,
        organization: organization ?? this.organization,
        since: since ?? this.since,
        logo: logo ?? this.logo,
        profile: profile ?? this.profile,
      );

  factory PersonalDetailsModel.fromJson(Map<String, dynamic> json) =>
      PersonalDetailsModel(
        apiKey: json["apiKey"],
        device: json["device"],
        accessToken: json["accessToken"],
        userId: json["user_id"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        shortName: json["short_name"],
        lastName: json["last_name"],
        dateOfBirth: json["date_of_birth"],
        gender: json["gender"],
        bloodGroup: json["blood_group"],
        isPhysicalChal: json["is_physical_chal"],
        isPhysicaldet: json["physical_detail"],
        videoProfile: json["video_profile"],
        organization: json["organization"],
        since: json["since"],
        logo: json["logo"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
    "apiKey": apiKey,
    "device": device,
    "accessToken": accessToken,
    "user_id": userId,
    "first_name": firstName,
    "middle_name": middleName,
    "short_name": shortName,
    "last_name": lastName,
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "blood_group": bloodGroup,
    "is_physical_chal": isPhysicalChal,
    "physical_detail": isPhysicaldet,
    "video_profile": videoProfile,
    "organization": organization,
    "since": since,
    "logo": logo,
    "profile": profile
  };


  Future<FormData> toFormData() async {
    MultipartFile? video;
    MultipartFile? imageData;

    if (videoProfile != null) {
      video = await MultipartFile.fromFile(
        videoProfile.toString(),
      );
    }

    if (profile != null) {
      imageData = await MultipartFile.fromFile(
        profile.toString(),
      );
    }

    return FormData.fromMap(
      copyWith(videoProfile: video, profile: imageData).toJson(),
    );
  }
}
