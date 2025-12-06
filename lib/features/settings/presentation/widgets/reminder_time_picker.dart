// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../core/utils/app_colors.dart';
// import '../../../../core/utils/app_text_styles.dart';

// class ReminderTimePicker extends StatefulWidget {
//   final TimeOfDay? initialTime;
//   final Function(TimeOfDay) onSave;

//   const ReminderTimePicker({super.key, this.initialTime, required this.onSave});

//   @override
//   State<ReminderTimePicker> createState() => _ReminderTimePickerState();
// }

// class _ReminderTimePickerState extends State<ReminderTimePicker> {
//   late TimeOfDay _selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     _selectedTime = widget.initialTime ?? const TimeOfDay(hour: 22, minute: 0);
//   }

//   Future<void> _pickTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primaryBrand,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//       widget.onSave(_selectedTime);
//     }
//   }

//   String _formatTime(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'ص' : 'م';
//     return '$hour:$minute $period';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _pickTime,
//       borderRadius: BorderRadius.circular(12.r),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           children: [
//             // Arrow on the left for RTL
//             Icon(Icons.arrow_back_ios, color: Colors.grey[400], size: 16.sp),
//             SizedBox(width: 12.w),

//             // Text content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     'وقت التذكير',
//                     style: AppTextStyles.font16BlackBold.copyWith(
//                       fontSize: 15.sp,
//                     ),
//                     textAlign: TextAlign.right,
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     _formatTime(_selectedTime),
//                     style: AppTextStyles.font14GrayRegular.copyWith(
//                       fontSize: 12.sp,
//                     ),
//                     textAlign: TextAlign.right,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 12.w),

//             // Icon on the right for RTL
//             Container(
//               width: 40.w,
//               height: 40.w,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryBrand.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               child: Icon(
//                 Icons.access_time,
//                 color: AppColors.primaryBrand,
//                 size: 22.sp,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
