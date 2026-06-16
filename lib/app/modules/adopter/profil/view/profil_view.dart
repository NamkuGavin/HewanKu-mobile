import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loading_dialog.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/profile/adopter_profile_model.dart';
import '../../../../models/profile/adopter_profile_update_request_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/profile/adopter_profile_service.dart';
import '../../home/widgets/home_section_placeholder.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/logout_sheet.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();

  AdopterProfileModel? _profile;
  bool _isInitialLoading = false;
  bool _hasLoadError = false;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _noHandphoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (_isInitialLoading || !mounted) {
      return;
    }

    _isInitialLoading = true;
    AppLoadingDialog.show(context, message: 'Memuat profil...');

    try {
      final profile = await AdopterProfileService.instance.getProfile();
      if (!mounted) {
        return;
      }

      setState(() {
        _profile = profile;
        _hasLoadError = false;
        _isEditing = false;
      });
      _populateControllers(profile);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _hasLoadError = true;
        _isEditing = false;
      });

      if (!_isUnauthorized(error)) {
        AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
      }
    } finally {
      AppLoadingDialog.hide();
      _isInitialLoading = false;
    }
  }

  void _populateControllers(AdopterProfileModel profile) {
    _namaLengkapController.text = profile.fullName;
    _emailController.text = profile.email;
    _noHandphoneController.text = profile.noTelepon;
  }

  void _startEditing() {
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    final profile = _profile;
    if (profile != null) {
      _populateControllers(profile);
    }

    FocusScope.of(context).unfocus();
    setState(() => _isEditing = false);
  }

  Future<void> _saveProfile() async {
    if (_isSaving) {
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    AppLoadingDialog.show(context, message: 'Menyimpan profil...');

    final request = AdopterProfileUpdateRequestModel(
      email: _emailController.text.trim(),
      displayName: _namaLengkapController.text.trim(),
      noTelepon: _noHandphoneController.text.trim(),
    );

    try {
      final profile = await AdopterProfileService.instance.updateProfile(request);

      if (!mounted) {
        return;
      }

      setState(() {
        _profile = profile;
        _hasLoadError = false;
        _isEditing = false;
      });
      _populateControllers(profile);

      AppSnackbar.show(context, message: 'Profil berhasil diperbarui.', type: AppSnackbarType.success);
    } catch (error) {
      if (!mounted) {
        return;
      }

      if (!_isUnauthorized(error)) {
        AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
      }
    } finally {
      AppLoadingDialog.hide();
      if (mounted) {
        setState(() => _isSaving = false);
      } else {
        _isSaving = false;
      }
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memuat profil pengguna.';
  }

  AppSnackbarType _resolveErrorType(Object error) {
    if (error is ApiException) {
      final statusCode = error.statusCode;
      if (statusCode == null || statusCode >= 500) {
        return AppSnackbarType.error;
      }
      return AppSnackbarType.warning;
    }
    return AppSnackbarType.error;
  }

  Widget _buildProfileContent() {
    if (_hasLoadError && _profile == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: HomeSectionPlaceholder(
          icon: Icons.person_off_rounded,
          title: 'Profil belum bisa dimuat.',
          description: 'Coba lagi untuk mengambil informasi akun terbaru.',
          onRetry: _loadProfile,
        ),
      );
    }

    final profile = _profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        ProfileAvatarWidget(imageUrl: profile.avatarUrl),
        SizedBox(height: 28.h),
        ProfileInfoSection(
          formKey: _formKey,
          namaLengkapController: _namaLengkapController,
          emailController: _emailController,
          noHandphoneController: _noHandphoneController,
          isEditing: _isEditing,
          isSaving: _isSaving,
          onEditTap: _startEditing,
          onSaveTap: _saveProfile,
          onCancelTap: _isEditing ? _cancelEditing : null,
        ),
        SizedBox(height: 28.h),
        ProfileActionButton(icon: Icons.logout_rounded, label: 'Log Out', onTap: () => LogoutSheet.show(context)),
        SizedBox(height: 24.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileHeaderWidget(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildProfileContent()]),
          ),
        ),
      ],
    );
  }
}
