export 'i_device_info_repo.dart';
export 'stub_device_info_repo.dart';
export 'create_platform_device_info_repo_stub.dart'
    if (dart.library.html) 'create_platform_device_info_repo_web.dart'
    if (dart.library.io) 'create_platform_device_info_repo_io.dart';
