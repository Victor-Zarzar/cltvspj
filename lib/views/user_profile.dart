import 'package:cltvspj/controller/controllers/user_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/views/components/custom_button.dart';
import 'package:cltvspj/views/components/input_field.dart';
import 'package:cltvspj/views/components/show_dialog_error.dart';
import 'package:cltvspj/views/components/user_popup_menu.dart';
import 'package:cltvspj/views/widgets/body_user_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<UserController>(context, listen: false);
      controller.loadUser();
    });
  }

  Future<void> _onSavePressed(UserController userController) async {
    if (!userController.hasValidInput) {
      ShowDialogError.show(
        context,
        title: 'error_dialog'.tr(),
        child: Text('fill_fields_to_see'.tr()),
      );
      return;
    }

    try {
      await userController.saveUser();

      if (!mounted) return;

      ShowDialogError.show(
        context,
        title: 'success_dialog'.tr(),
        child: Text('user_saved_success'.tr()),
      );
    } catch (e) {
      if (!mounted) return;

      ShowDialogError.show(
        context,
        title: 'error_dialog'.tr(),
        child: Text('error_dialog'.tr()),
      );
    }
  }

  Future<void> _onClearPressed(UserController userController) async {
    try {
      await userController.clearUser();

      if (!mounted) return;

      ShowDialogError.show(
        context,
        title: 'success_dialog'.tr(),
        child: Text('user_cleared_success'.tr()),
      );
    } catch (e) {
      if (!mounted) return;

      ShowDialogError.show(
        context,
        title: 'error_dialog'.tr(),
        child: Text('error_dialog'.tr()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Scaffold(
          backgroundColor: notifier.isDark
              ? BackGroundColor.fourthColor
              : BackGroundColor.primaryColor,
          appBar: AppBar(
            leading: kIsWeb
                ? null
                : Semantics(
                    label: "backtopage".tr(),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: IconColor.primaryColor,
                        semanticLabel: 'arrow_back_icon'.tr(),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
            title: Text('user_profile_title'.tr(), style: context.h1),
            centerTitle: true,
            actions: const [UserPopupMenu()],
            backgroundColor: notifier.isDark
                ? AppBarColor.thirdColor
                : AppBarColor.secondaryColor,
          ),
          body: Responsive(
            mobile: _buildUserProfileContent(
              context,
              maxWidth: 370,
              padding: 20,
              minHeight: 550,
            ),
            tablet: _buildUserProfileContent(
              context,
              maxWidth: 600,
              padding: 30,
              minHeight: 600,
            ),
            desktop: _buildUserProfileContent(
              context,
              maxWidth: 700,
              padding: 50,
              minHeight: 560,
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserProfileContent(
    BuildContext context, {
    required double maxWidth,
    required double padding,
    required double minHeight,
  }) {
    return Consumer2<UiProvider, UserController>(
      builder: (context, notifier, userController, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minHeight: minHeight,
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: notifier.isDark
                                ? CardColor.primaryColor
                                : CardColor.secondaryColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.isDark
                                    ? BoxShadowColor.fifthColor.withValues(
                                        alpha: 0.2,
                                      )
                                    : BoxShadowColor.fourthColor.withValues(
                                        alpha: 0.3,
                                      ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            'user_profile_subtitle'.tr(),
                            style: context.h1Home,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: notifier.isDark
                                ? CardColor.primaryColor
                                : CardColor.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.isDark
                                    ? BoxShadowColor.fifthColor.withValues(
                                        alpha: 0.2,
                                      )
                                    : BoxShadowColor.fourthColor.withValues(
                                        alpha: 0.3,
                                      ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18,
                                      semanticLabel: 'person_icon'.tr(),
                                      color: IconColor.primaryColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'profile'.tr(),
                                      style: context.bodyMediumFont,
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 15,
                                  color: notifier.isDark
                                      ? DividerColor.thirdColor
                                      : DividerColor.secondaryColor,
                                ),
                                const SizedBox(height: 16),
                                InputField(
                                  label: 'user_name_label'.tr(),
                                  hintText: 'user_name_hint'.tr(),
                                  controller: userController.nameController,
                                  icon: Icons.person_outline,
                                  maxWidth: maxWidth,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: const <TextInputFormatter>[],
                                ),
                                InputField(
                                  label: 'user_salary_label'.tr(),
                                  hintText: 'user_salary_hint'.tr(),
                                  controller: userController.salaryController,
                                  icon: Icons.attach_money,
                                  maxWidth: maxWidth,
                                ),
                                InputField(
                                  label: 'user_benefits_label'.tr(),
                                  hintText: 'user_benefits_hint'.tr(),
                                  controller: userController.benefitsController,
                                  icon: Icons.card_giftcard,
                                  maxWidth: maxWidth,
                                ),
                                InputField(
                                  label: 'user_profession_label'.tr(),
                                  hintText: 'user_profession_hint'.tr(),
                                  controller:
                                      userController.professionController,
                                  icon: Icons.work_outline,
                                  maxWidth: maxWidth,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: const <TextInputFormatter>[],
                                ),
                                const SizedBox(height: 12),
                                CustomButton(
                                  animatedGradient: true,
                                  fullWidth: true,
                                  height: 42,
                                  maxWidth: maxWidth,
                                  color: notifier.isDark
                                      ? ButtonColor.fourthColor
                                      : ButtonColor.primaryColor,
                                  text: 'save_button'.tr(),
                                  onPressed: () {
                                    if (!userController.isLoading) {
                                      _onSavePressed(userController);
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: userController.isLoading
                                        ? null
                                        : () {
                                            if (!userController.hasAnyValue) {
                                              ShowDialogError.show(
                                                context,
                                                title: 'error_dialog'.tr(),
                                                child: Text(
                                                  'nothing_to_clear'.tr(),
                                                  style: context.bodyMediumFont,
                                                ),
                                              );
                                              return;
                                            }
                                            _onClearPressed(userController);
                                          },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: IconColor.primaryColor,
                                      semanticLabel: 'delete_icon'.tr(),
                                    ),
                                    label: Text(
                                      'user_clear_profile'.tr(),
                                      style: context.bodyLargeFont,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        BodyUserProfile(controller: userController),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
