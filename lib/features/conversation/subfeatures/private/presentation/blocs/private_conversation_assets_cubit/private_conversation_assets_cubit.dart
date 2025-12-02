import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'private_conversation_assets_state.dart';

class PrivateConversationAssetsCubit extends Cubit<PrivateConversationAssetsState> {
  PrivateConversationAssetsCubit() : super(PrivateConversationAssetsInitial());
}
