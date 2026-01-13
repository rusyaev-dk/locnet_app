// device_info_repo_web.dart
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:web/web.dart' as web;

final class DeviceInfoRepo implements IDeviceInfoRepo {
  const DeviceInfoRepo();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    final web.Navigator navigator = web.window.navigator;

    final String userAgent = (navigator.userAgent).toLowerCase();
    final String platform = (navigator.platform).toLowerCase();

    return DeviceInfo(
      deviceType: _detectDeviceType(userAgent),
      operatingSystem: _detectOperatingSystem(
        userAgent: userAgent,
        platform: platform,
      ),
    );
  }

  String? _detectOperatingSystem({
    required String userAgent,
    required String platform,
  }) {
    if (userAgent.contains('android')) {
      return 'Android';
    }
    if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
      return 'iOS';
    }
    if (platform.contains('win')) {
      return 'Windows';
    }
    if (platform.contains('mac')) {
      return 'macOS';
    }
    if (platform.contains('linux')) {
      return 'Linux';
    }
    return null;
  }

  String? _detectDeviceType(String userAgent) {
    if (userAgent.contains('ipad') || userAgent.contains('tablet')) {
      return 'tablet';
    }
    if (userAgent.contains('mobi') ||
        userAgent.contains('iphone') ||
        userAgent.contains('android')) {
      return 'mobile';
    }
    return 'desktop';
  }
}
