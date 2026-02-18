import 'package:cltvspj/core/utils/currency_format_helper.dart';
import 'package:cltvspj/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:cltvspj/features/home/presentation/widgets/home_body_container.dart';
import 'package:cltvspj/features/home/presentation/widgets/home_popup_menu.dart';
import 'package:cltvspj/shared/theme/app_theme.dart';
import 'package:cltvspj/shared/theme/theme_provider.dart';
import 'package:cltvspj/shared/theme/typography_extension.dart';
import 'package:cltvspj/shared/widgets/responsive.dart';
import 'package:cltvspj/shared/widgets/result_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final controller = context.read<HomeViewmodel>();
    controller.loadData();
  }

  void _onCalculatePressed() {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<HomeViewmodel>();
      controller.calculate();
      ResultDialog.show(context, currencyFormat);
    }
  }

  Widget _buildContent(
    BuildContext context, {
    required double maxWidth,
    required double minHeight,
    required double padding,
  }) {
    return Consumer2<UiProvider, HomeViewmodel>(
      builder: (context, notifier, controller, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: notifier.isDark
                ? AppBarColor.thirdColor
                : AppBarColor.secondaryColor,
            title: Text('app_bar_title'.tr(), style: context.h1),
            actions: const [HomePopupMenu()],
          ),
          backgroundColor: notifier.isDark
              ? BackGroundColor.fourthColor
              : BackGroundColor.primaryColor,
          body: BodyContainer(
            formKey: _formKey,
            salaryCltController: controller.salaryCltController,
            salaryPjController: controller.salaryPjController,
            benefitsController: controller.benefitsController,
            taxesPjController: controller.taxesPjController,
            accountantFeeController: controller.accountantFeeController,
            inssPjController: controller.inssPjController,
            onCalculatePressed: _onCalculatePressed,
            padding: padding,
            maxWidth: maxWidth,
            minHeight: minHeight,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildContent(
        context,
        maxWidth: 370,
        padding: 10,
        minHeight: 550,
      ),
      tablet: _buildContent(
        context,
        maxWidth: 600,
        minHeight: 600,
        padding: 30,
      ),
      desktop: _buildContent(
        context,
        maxWidth: 700,
        minHeight: 570,
        padding: 50,
      ),
    );
  }
}
