import 'package:locnet_app/features/auth/data/repositories/device_info_repo/i_device_info_repo.dart';
import 'package:locnet_app/features/auth/data/repositories/device_info_repo/io_device_info_repo.dart';

/// VM / desktop / mobile native implementation.
IDeviceInfoRepo createPlatformDeviceInfoRepo() => const IoDeviceInfoRepo();
