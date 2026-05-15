import 'package:locnet_app/features/auth/data/repositories/device_info_repo/i_device_info_repo.dart';
import 'package:locnet_app/features/auth/data/repositories/device_info_repo/web_device_info_repo.dart';

/// Browser implementation.
IDeviceInfoRepo createPlatformDeviceInfoRepo() => const WebDeviceInfoRepo();
