// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class DeviceInfoDto extends Equatable {
  const DeviceInfoDto({
    this.ipAddress,
    this.macAddress,
    this.deviceName,
    this.deviceType,
    this.operatingSystem,
  });

  final String? ipAddress;
  final String? macAddress;
  final String? deviceName;
  final String? deviceType;
  final String? operatingSystem;

  factory DeviceInfoDto.fromJson(Map<String, dynamic> json) {
    return DeviceInfoDto(
      ipAddress: json['IPAddress'] as String?,
      macAddress: json['macAddress'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceType: json['deviceType'] as String?,
      operatingSystem: json['OS'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'IPAddress': ipAddress,
      'macAddress': macAddress,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'OS': operatingSystem,
    };
  }

  @override
  List<Object?> get props => [
    ipAddress,
    macAddress,
    deviceName,
    deviceType,
    operatingSystem,
  ];
}
