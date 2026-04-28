import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/screens/profile_settings_view.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/domain/profile_interactor.dart';

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
    final AuthInteractor authInteractor = context.read<AuthInteractor>();
    final ProfileInteractor profileInteractor = _profileInteractor(context);

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final description = _descriptionController.text.trim();

    String? firstNameError;
    String? lastNameError;
    String? usernameError;
    String? screenError;

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

    if (usernameError == null && username != _user!.username) {
      try {
        final bool isAvailable = await authInteractor.validateRegisterLogin(
          login: username,
        );
        if (!mounted) return;
        if (!isAvailable) {
          usernameError = AuthExceptionsTranslator.translate(
            context,
            AuthLoginAlreadyTakenException(message: 'Username already taken'),
          );
        }
      } catch (e) {
        if (!mounted) return;
        screenError = AuthExceptionsTranslator.translate(context, e);
      }
    }

    if (!mounted) return;
    setState(() {
      _firstNameError = firstNameError;
      _lastNameError = lastNameError;
      _usernameError = usernameError;
      _screenError = screenError;
    });

    if (firstNameError != null ||
        lastNameError != null ||
        usernameError != null ||
        screenError != null) {
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

      await profileInteractor.udpateUserData(updatedUser: updatedUser);
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

    return ProfileSettingsView(
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
