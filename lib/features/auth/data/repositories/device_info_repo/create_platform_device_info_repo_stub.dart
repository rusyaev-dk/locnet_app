import 'package:locnet_app/features/auth/data/repositories/device_info_repo/i_device_info_repo.dart';
import 'package:locnet_app/features/auth/data/repositories/device_info_repo/stub_device_info_repo.dart';

/// Fallback when neither `dart:html` nor `dart:io` applies (e.g. some test contexts).
IDeviceInfoRepo createPlatformDeviceInfoRepo() => const StubDeviceInfoRepo();
