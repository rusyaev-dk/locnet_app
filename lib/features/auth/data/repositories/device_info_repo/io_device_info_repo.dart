import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:locnet_app/features/auth/data/repositories/device_info_repo/i_device_info_repo.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Native (iOS / Android / desktop) device metadata for auth [DeviceInfo].
///
/// - [ipAddress] is the **local** IPv4 on Wi‑Fi/Ethernet when available, not the
///   public WAN address (that is normally derived on the server from the TCP connection).
/// - [macAddress] is not filled: OS restrictions make a stable device MAC unreliable;
///   the session record may still get identifiers from the backend.
final class IoDeviceInfoRepo implements IDeviceInfoRepo {
  const IoDeviceInfoRepo();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    final DeviceInfoPlugin plugin = DeviceInfoPlugin();
    String? deviceName;
    String? deviceType;
    String? operatingSystem;
    String? ipAddress;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo a = await plugin.androidInfo;
      final String brand = a.brand.trim();
      final String model = a.model.trim();
      deviceName = brand.isNotEmpty
          ? '$brand $model'.trim()
          : (model.isNotEmpty ? model : a.product);
      deviceType = 'mobile';
      operatingSystem = 'Android ${a.version.release} (SDK ${a.version.sdkInt})';
    } else if (Platform.isIOS) {
      final IosDeviceInfo i = await plugin.iosInfo;
      deviceName = i.name.trim().isNotEmpty ? i.name : i.utsname.machine;
      deviceType = 'mobile';
      final String v = i.systemVersion;
      operatingSystem = v.isNotEmpty ? 'iOS $v' : 'iOS';
    } else if (Platform.isMacOS) {
      final MacOsDeviceInfo m = await plugin.macOsInfo;
      deviceName = m.computerName.trim().isNotEmpty
          ? m.computerName
          : m.hostName;
      deviceType = 'desktop';
      final String v = m.osRelease;
      operatingSystem = v.isNotEmpty ? 'macOS $v' : 'macOS';
    } else if (Platform.isWindows) {
      final WindowsDeviceInfo w = await plugin.windowsInfo;
      deviceName = w.computerName;
      deviceType = 'desktop';
      operatingSystem = 'Windows';
    } else if (Platform.isLinux) {
      final LinuxDeviceInfo l = await plugin.linuxInfo;
      deviceName = l.prettyName.isNotEmpty ? l.prettyName : l.name;
      deviceType = 'desktop';
      final String v = l.versionId ?? l.version ?? '';
      operatingSystem = v.isNotEmpty ? 'Linux $v' : 'Linux';
    } else {
      operatingSystem = Platform.operatingSystem;
    }

    try {
      final NetworkInfo net = NetworkInfo();
      final String? ip = await net.getWifiIP();
      if (ip != null && ip.isNotEmpty && ip != '0.0.0.0') {
        ipAddress = ip;
      }
    } on Object {
      // No network permission, offline, or unsupported — leave null.
    }

    return DeviceInfo(
      deviceName: _orNull(deviceName),
      deviceType: _orNull(deviceType),
      operatingSystem: _orNull(operatingSystem),
      ipAddress: _orNull(ipAddress),
    );
  }

  static String? _orNull(String? s) {
    final String t = s?.trim() ?? '';
    return t.isEmpty ? null : t;
  }
}
