import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class IDeviceInfoRepo {
  Future<DeviceInfo> getDeviceInfo();
}
