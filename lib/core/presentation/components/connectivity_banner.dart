import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/blocs/network_status/network_status_cubit.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkStatusCubit, NetworkStatus>(
      builder: (BuildContext context, NetworkStatus status) {
        final motion = context.designTokens.motion;
        final spacing = context.designTokens.spacing;
        final colorScheme = context.colorScheme;
        final textScheme = context.textScheme;

        final String? message = switch (status) {
          NetworkStatus.offline => context.l10n.noInternetConnection,
          NetworkStatus.serverUnreachable => context.l10n.noServerConnection,
          NetworkStatus.online => null,
        };

        final IconData icon = status == NetworkStatus.serverUnreachable
            ? Icons.cloud_off_rounded
            : Icons.wifi_off_rounded;

        return Column(
          children: [
            AnimatedSize(
              duration: motion.medium,
              curve: motion.mediumCurve,
              child: message != null
                  ? Material(
                      color: colorScheme.surfaceContainerHigh,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.sm,
                            vertical: spacing.xs,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, size: 16, color: colorScheme.error),
                              SizedBox(width: spacing.xxs),
                              Flexible(
                                child: Text(
                                  message,
                                  style: textScheme.label.copyWith(
                                    color: colorScheme.error,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
