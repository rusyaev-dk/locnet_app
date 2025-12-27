part of 'private_assets_cubit.dart';

sealed class PrivateAssetsState extends Equatable {
  const PrivateAssetsState();

  @override
  List<Object> get props => [];
}

final class PrivateAssetsInitial extends PrivateAssetsState {}
