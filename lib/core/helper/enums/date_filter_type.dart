import 'package:easy_localization/easy_localization.dart';

import '../../utils/locale_keys.dart';

/// Filter type for transactions
enum DateFilterType { day, month, year }

extension DateFilterTypeExtension on DateFilterType {
  String get arabicName {
    switch (this) {
      case DateFilterType.day:
        return LocaleKeys.day.tr();
      case DateFilterType.month:
        return LocaleKeys.month.tr();
      case DateFilterType.year:
        return LocaleKeys.year.tr();
    }
  }
}
