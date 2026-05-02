// device_info_repo_stub.dart
import 'package:locnet_app/features/auth/data/repositories/device_info_repo/i_device_info_repo.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class StubDeviceInfoRepo implements IDeviceInfoRepo {
  const StubDeviceInfoRepo();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    return const DeviceInfo();
  }
}
