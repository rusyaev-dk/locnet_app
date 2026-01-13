// device_info_repo_stub.dart
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class DeviceInfoRepo implements IDeviceInfoRepo {
  const DeviceInfoRepo();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    return const DeviceInfo();
  }
}
