import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker_ar/core/helper/constants/app_constants.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper_keks.dart';
import 'package:expense_tracker_ar/core/routing/app_router.dart';
import 'package:expense_tracker_ar/core/utils/font_weight_helper.dart';
import 'package:expense_tracker_ar/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helper/functions/image_picker_dialog.dart';
import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../widgets/currency_dialog.dart';
import '../widgets/image_profile.dart';
import '../widgets/language_dialog.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedCurrency;
  String? _selectedLanguage;
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showImagePickerDialog(
      context,
      onTapGallery: () async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          setState(() {
            _imageFile = File(image.path);
          });
        }
        if (context.mounted) Navigator.of(context).pop();
      },
      onTapCamera: () async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );
        if (image != null) {
          setState(() {
            _imageFile = File(image.path);
          });
        }
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  void _showCurrencyPicker() {
    showDialog(
      context: context,
      builder: (context) => CurrencyDialog(
        currencies: AppConstants.currencies,
        initialValue: _selectedCurrency,
        onSave: (code) {
          setState(() {
            _selectedCurrency = code;
          });
        },
      ),
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) => LanguageDialog(
        languages: AppConstants.languages,
        initialValue: _selectedLanguage,
        onSave: (code) {
          setState(() {
            _selectedLanguage = code;
          });
        },
      ),
    );
  }

  Future<void> _saveUserData() async {
    // Validate form
    if (_formKey.currentState?.validate() != true) {
      ToastHelper.showError(
        context,
        message: 'الرجاء إدخال جميع البيانات المطلوبة',
      );
      return;
    }

    // Validate currency selection
    if (_selectedCurrency == null) {
      ToastHelper.showError(context, message: 'الرجاء اختيار العملة');
      return;
    }

    // Validate language selection
    if (_selectedLanguage == null) {
      ToastHelper.showError(context, message: 'الرجاء اختيار اللغة');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final cacheHelper = CacheHelper();

      // Save username
      await cacheHelper.saveData(
        key: CacheHelperKeys.username,
        value: _usernameController.text.trim(),
      );

      // Save currency
      await cacheHelper.saveData(
        key: CacheHelperKeys.currency,
        value: _selectedCurrency!,
      );

      // Save language
      await cacheHelper.saveData(
        key: CacheHelperKeys.language,
        value: _selectedLanguage!,
      );

      // Save image path if available
      if (_imageFile != null) {
        await cacheHelper.saveData(
          key: CacheHelperKeys.imageProfile,
          value: _imageFile!.path,
        );
      }

      // Mark setup as complete
      await cacheHelper.saveData(
        key: CacheHelperKeys.isSetupComplete,
        value: true,
      );

      if (mounted) {
        // Navigate to home
        context.go(AppRouter.homeScreen);
        ToastHelper.showSuccess(context, message: 'تم حفظ البيانات بنجاح');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, message: 'حدث خطأ أثناء حفظ البيانات');
      }
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _pickImage(),
                      child: ImageProfile(imageFile: _imageFile),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "اضافة الملف الشخصي",
                    style: AppTextStyles.font24BlackBold.copyWith(
                      fontWeight: FontWeightHelper.extraBold,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                Text("إختر اسماً لحسابك", style: AppTextStyles.font16BlackBold),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _usernameController,
                  hintText: "اسم الحساب",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم الحساب';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),
                Text("اختر العملة", style: AppTextStyles.font16BlackBold),
                SizedBox(height: 10.h),
                FadeInLeft(
                  duration: const Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: _showCurrencyPicker,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.primaryLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCurrency != null
                                ? AppConstants.currencies.firstWhere(
                                    (c) => c['code'] == _selectedCurrency,
                                  )['name']!
                                : "اختر العملة",
                            style: AppTextStyles.font16BlackMedium.copyWith(
                              color: _selectedCurrency == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
                Text("اختر اللغة", style: AppTextStyles.font16BlackBold),
                SizedBox(height: 10.h),
                FadeInLeft(
                  duration: const Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: _showLanguagePicker,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.primaryLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedLanguage != null
                                ? AppConstants.languages.firstWhere(
                                    (l) => l['code'] == _selectedLanguage,
                                  )['name']!
                                : "اختر اللغة",
                            style: AppTextStyles.font16BlackMedium.copyWith(
                              color: _selectedLanguage == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrand,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.gradientG3_1,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "ابدا الان",
                            style: AppTextStyles.font18WhiteBold,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
