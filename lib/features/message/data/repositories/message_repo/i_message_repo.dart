/// Legacy generic message repo is no longer used.
///
/// Message logic has been split into:
/// - private_message (IPrivateMessageRepo)
/// - group_message (IGroupMessageRepo)
/// - channel_publication (IChannelPublicationRepo)
///
/// This interface is kept only to avoid breaking imports.
abstract interface class IMessageRepo {}
