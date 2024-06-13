// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? name;
  final String? contact;
  final String? alternateNumber;
  final String? occupation;
  final String? profileUrl;
  final String? age;
  final List<ProfilePhotos>? profilePhotos;
  final String? email; // User's email address
  final String? address; // User's home address
  final String? bio;
  final String? gender;
  const UserModel({
    this.name,
    this.occupation,
    this.alternateNumber,
    this.contact,
    this.profileUrl,
    this.age,
    this.profilePhotos,
    this.email,
    this.address,
    this.bio,
    this.gender,
  });

  @override
  List<Object?> get props => [];

  UserModel copyWith({
    String? name,
    String? occupation,
    String? contact,
    String? alternateNumber,
    String? profileUrl,
    String? age,
    List<ProfilePhotos>? profilePhotos,
    String? email,
    String? address,
    String? bio,
    String? gender,
  }) {
    return UserModel(
      name: name ?? this.name,
      alternateNumber: alternateNumber ?? this.alternateNumber,
      occupation: occupation ?? this.occupation,
      contact: contact ?? this.contact,
      profileUrl: profileUrl ?? this.profileUrl,
      age: age ?? this.age,
      profilePhotos: profilePhotos ?? this.profilePhotos,
      email: email ?? this.email,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'alternate_number': alternateNumber,
      'occupation': occupation,
      'profile_photo_path': profileUrl,
      'age': age,
      'profilePhotos': profilePhotos?.map((x) => x.toMap()).toList(),
      'email': email,
      'address': address,
      'bio': bio,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      contact: map['contact'],
      alternateNumber: map['alternate_number'],
      occupation: map['occupation'],
      profileUrl: map['profile_photo_path'],
      age: map['age'],
      profilePhotos: map['profilePhotos'] != null
          ? List<ProfilePhotos>.from(
              map['profilePhotos']?.map((x) => ProfilePhotos.fromMap(x)))
          : null,
      email: map['email'],
      address: map['address'],
      bio: map['bio'],
      gender: map['gender'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

class ProfilePhotos {
  int id;
  String localUrl;
  String networkUrl;
  bool isActive;
  ProfilePhotos({
    required this.localUrl,
    this.networkUrl = "",
    required this.isActive,
    required this.id,
  });
  factory ProfilePhotos.fromJson(Map<String, dynamic> json) {
    return ProfilePhotos(
      localUrl: json['url'],
      networkUrl: json['networkUrl'],
      isActive: json['isActive'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': localUrl,
      'networkUrl': networkUrl,
      'isActive': isActive,
      'id': id,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'url': localUrl,
      'networkUrl': networkUrl,
      'id': id,
      'isActive': isActive,
    };
  }

  factory ProfilePhotos.fromMap(Map<String, dynamic> map) {
    return ProfilePhotos(
      localUrl: map['url'] ?? '',
      networkUrl: map['networkUrl'] ?? '',
      isActive: map['isActive'] ?? false,
      id: map['id'] ?? 0,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory ProfilePhotos.fromJson(String source) => ProfilePhotos.fromMap(json.decode(source));

  ProfilePhotos copyWith({
    String? url,
    bool? isActive,
    int? id,
  }) {
    return ProfilePhotos(
      localUrl: url ?? localUrl,
      networkUrl: url ?? networkUrl,
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
    );
  }
}
