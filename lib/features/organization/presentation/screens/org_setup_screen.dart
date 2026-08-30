import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/org_models.dart';
import '../bloc/org_bloc.dart';
import 'org_dashboard_screen.dart';

/// 1. تسجيل المنظمة وإعدادات المدير (Organization Setup)
/// إدخال بيانات المؤسسة التعليمية (مدرسة، روضة، مركز)، أعداد الطلاب، المعلمين، الفصول، وبيانات المدير
class OrgSetupScreen extends StatefulWidget {
  const OrgSetupScreen({super.key});

  @override
  State<OrgSetupScreen> createState() => _OrgSetupScreenState();
}

class _OrgSetupScreenState extends State<OrgSetupScreen> {
  final _nameController = TextEditingController(text: 'مدارس النخبة الأهلية');
  final _typeController = TextEditingController(text: 'مدرسة ابتدائية');
  final _studentsCountController = TextEditingController(text: '340');
  final _teachersCountController = TextEditingController(text: '24');
  final _classesCountController = TextEditingController(text: '12');
  final _cityController = TextEditingController(text: 'الرياض');
  final _managerNameController = TextEditingController(text: 'د. عبد الله المنصور');
  final _managerEmailController = TextEditingController(text: 'director@eliteschools.edu');

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _studentsCountController.dispose();
    _teachersCountController.dispose();
    _classesCountController.dispose();
    _cityController.dispose();
    _managerNameController.dispose();
    _managerEmailController.dispose();
    super.dispose();
  }

  void _onSaveAndEnter() {
    final org = OrgModel(
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      totalStudents: int.tryParse(_studentsCountController.text.trim()) ?? 340,
      totalTeachers: int.tryParse(_teachersCountController.text.trim()) ?? 24,
      totalClasses: int.tryParse(_classesCountController.text.trim()) ?? 12,
      country: 'المملكة العربية السعودية',
      city: _cityController.text.trim(),
      managerName: _managerNameController.text.trim(),
      managerEmail: _managerEmailController.text.trim(),
    );

    context.read<OrgBloc>().add(UpdateOrgSetupEvent(org));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OrgDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      title: 'تسجيل المنظمة التعليمية',
      subtitle: 'حساب المؤسسات والمدارس (B2B)',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // لافتة تعريفية
            AppCard(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lavenderPurple.withValues(alpha: 0.1),
              borderColor: AppColors.lavenderPurple,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'توفر منصة PORT للمؤسسات التعليمية إمكانية إدارة أعداد كبيرة من الطلاب والفصول، ومتابعة ترسيخ القيم والعادات بتقارير دورية متقدمة.',
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: 'اسم المؤسسة التعليمية',
              hint: 'مثلاً: مدرسة الأمل النموذجية',
              controller: _nameController,
            ),
            const SizedBox(height: 12),

            AppTextField(
              label: 'نوع المنظمة',
              hint: 'مدرسة، روضة أطفال، مركز تأهيلي',
              controller: _typeController,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'إجمالي الطلاب',
                    hint: '340',
                    controller: _studentsCountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(
                    label: 'إجمالي الفصول',
                    hint: '12',
                    controller: _classesCountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            AppTextField(
              label: 'المدينة / المنطقة',
              hint: 'مثلاً: الرياض',
              controller: _cityController,
            ),
            const SizedBox(height: 12),

            AppTextField(
              label: 'اسم المدير أو المشرف',
              hint: 'اسم المسؤول الرئيسي',
              controller: _managerNameController,
            ),
            const SizedBox(height: 12),

            AppTextField(
              label: 'البريد الإلكتروني المؤسسي',
              hint: 'admin@school.edu',
              controller: _managerEmailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 24),

            AppButton(
              text: 'حفظ وإطلاق لوحة تحكم المنظمة',
              customColor: AppColors.lavenderPurple,
              height: 54,
              onPressed: _onSaveAndEnter,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
