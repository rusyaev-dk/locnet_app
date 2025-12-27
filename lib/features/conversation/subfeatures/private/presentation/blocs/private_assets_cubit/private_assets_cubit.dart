import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'private_assets_state.dart';

class PrivateAssetsCubit extends Cubit<PrivateAssetsState> {
  PrivateAssetsCubit() : super(PrivateAssetsInitial());
}
