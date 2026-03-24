import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/domain/profile_interactor.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Profile section in Settings: compact profile view + inline editor.
class ProfileSettingsContent extends StatefulWidget {
  const ProfileSettingsContent({super.key});

  @override
  State<ProfileSettingsContent> createState() => _ProfileSettingsContentState();
}

class _ProfileSettingsContentState extends State<ProfileSettingsContent> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSubmitting = false;
  User? _user;
  String? _firstNameError;
  String? _lastNameError;
  String? _usernameError;
  String? _screenError;

  ProfileInteractor _profileInteractor(BuildContext context) {
    return ProfileInteractor(
      userRepo: context.read<IUserRepo>(),
      logger: context.read<ILogger>(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUser());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticatedState) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _screenError = null;
    });

    try {
      final loadedUser = await _profileInteractor(context).loadUserData();
      if (!mounted) return;
      setState(() {
        _user = loadedUser;
        _syncControllersFromUser(loadedUser);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _screenError = e.toString();
        _isLoading = false;
      });
    }
  }

  void _syncControllersFromUser(User user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _usernameController.text = user.username;
    _descriptionController.text = user.description ?? '';
  }

  void _startEditing() {
    if (_user == null) return;
    setState(() {
      _isEditing = true;
      _firstNameError = null;
      _lastNameError = null;
      _usernameError = null;
      _screenError = null;
      _syncControllersFromUser(_user!);
    });
  }

  void _cancelEditing() {
    if (_user != null) _syncControllersFromUser(_user!);
    setState(() {
      _isEditing = false;
      _firstNameError = null;
      _lastNameError = null;
      _usernameError = null;
      _screenError = null;
    });
  }

  Future<void> _saveProfile() async {
    if (_user == null || _isSubmitting) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final description = _descriptionController.text.trim();

    String? firstNameError;
    String? lastNameError;
    String? usernameError;

    try {
      ProfileDataValidator.validateName(firstName);
    } catch (e) {
      firstNameError = AppExceptionsTranslator.translate(context, e);
    }

    try {
      ProfileDataValidator.validateName(lastName);
    } catch (e) {
      lastNameError = AppExceptionsTranslator.translate(context, e);
    }

    try {
      ProfileDataValidator.validateUsername(username);
    } catch (e) {
      usernameError = AppExceptionsTranslator.translate(context, e);
    }

    setState(() {
      _firstNameError = firstNameError;
      _lastNameError = lastNameError;
      _usernameError = usernameError;
      _screenError = null;
    });

    if (firstNameError != null ||
        lastNameError != null ||
        usernameError != null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final updatedUser = _user!.copyWith(
        firstName: firstName,
        lastName: lastName,
        username: username,
        description: description.isEmpty ? null : description,
      );

      await _profileInteractor(
        context,
      ).udpateUserData(updatedUser: updatedUser);
      if (!mounted) return;
      setState(() {
        _user = updatedUser;
        _isEditing = false;
        _isSubmitting = false;
      });
      await _loadUser();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _screenError = e.toString();
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final AuthAuthenticatedState? authState = context
        .select<AuthCubit, AuthAuthenticatedState?>((AuthCubit c) {
          final state = c.state;
          if (state is AuthAuthenticatedState) return state;
          return null;
        });
    final User? user = authState?.user;

    if (user == null) {
      return Center(
        child: Text(
          l10n.sessionIsNotLoadedYet,
          style: context.textScheme.label.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    if (_isLoading && _user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _ProfileSectionBody(
      user: _user ?? user,
      isEditing: _isEditing,
      isSubmitting: _isSubmitting,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      usernameController: _usernameController,
      descriptionController: _descriptionController,
      firstNameError: _firstNameError,
      lastNameError: _lastNameError,
      usernameError: _usernameError,
      screenError: _screenError,
      onStartEdit: _startEditing,
      onCancelEdit: _cancelEditing,
      onSave: _saveProfile,
    );
  }
}

class _ProfileSectionBody extends StatelessWidget {
  const _ProfileSectionBody({
    required this.user,
    required this.isEditing,
    required this.isSubmitting,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.descriptionController,
    required this.firstNameError,
    required this.lastNameError,
    required this.usernameError,
    required this.screenError,
    required this.onStartEdit,
    required this.onCancelEdit,
    required this.onSave,
  });

  final User user;
  final bool isEditing;
  final bool isSubmitting;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController descriptionController;
  final String? firstNameError;
  final String? lastNameError;
  final String? usernameError;
  final String? screenError;
  final VoidCallback onStartEdit;
  final VoidCallback onCancelEdit;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    final initials = ProfileDataExtractor.extractUserInitials(user);
    final fullName = ProfileDataExtractor.extractUserFullName(user);
    final displayName = fullName.isNotEmpty ? fullName : user.username;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(title: l10n.settingsMyProfile),
          SettingsGroupCard(
            title: 'Профиль',
            children: [
              if (!isEditing) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: Row(
                    children: [
                      CompanionAvatar(text: initials, size: 50),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textScheme.headline.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@${user.username}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textScheme.label.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                _ProfileInfoTile(title: l10n.firstName, value: user.firstName),
                _ProfileInfoTile(title: l10n.lastName, value: user.lastName),
                _ProfileInfoTile(
                  title: l10n.username,
                  value: '@${user.username}',
                ),
                _ProfileInfoTile(
                  title: l10n.language,
                  value: user.languageCode.toUpperCase(),
                ),
                _ProfileInfoTile(
                  title: l10n.description,
                  value: (user.description ?? '').trim().isEmpty
                      ? l10n.unknownValue
                      : user.description!.trim(),
                ),
                const Divider(height: 1),
                SettingsActionTile(
                  title: 'Редактировать профиль',
                  leadingIcon: Icons.edit_outlined,
                  onTap: onStartEdit,
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: firstNameController,
                        labelText: l10n.firstName,
                        textInputAction: TextInputAction.next,
                        errorText: firstNameError,
                        isActive: !isSubmitting,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: lastNameController,
                        labelText: l10n.lastName,
                        textInputAction: TextInputAction.next,
                        errorText: lastNameError,
                        isActive: !isSubmitting,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: usernameController,
                        labelText: l10n.username,
                        textInputAction: TextInputAction.next,
                        errorText: usernameError,
                        isActive: !isSubmitting,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        enabled: !isSubmitting,
                        minLines: 3,
                        maxLines: 5,
                        style: textScheme.body.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (screenError != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          screenError!,
                          style: textScheme.caption.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isSubmitting ? null : onCancelEdit,
                              child: Text(l10n.cancel),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppPrimaryButton(
                              text: l10n.apply,
                              onPressed: onSave,
                              isLoading: isSubmitting,
                              isActive: !isSubmitting,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textScheme.body.copyWith(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
