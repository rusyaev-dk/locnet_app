// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/auth/data/data.dart';

class DeviceInfo extends Equatable {
  const DeviceInfo({
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

  factory DeviceInfo.fromDto(DeviceInfoDto dto) {
    return DeviceInfo(
      ipAddress: dto.ipAddress,
      macAddress: dto.macAddress,
      deviceName: dto.deviceName,
      deviceType: dto.deviceType,
      operatingSystem: dto.operatingSystem,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    ipAddress,
    macAddress,
    deviceName,
    deviceType,
    operatingSystem,
  ];
}
