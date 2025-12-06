/// Filter type for transactions
enum DateFilterType { day, month, year }

extension DateFilterTypeExtension on DateFilterType {
  String get arabicName {
    switch (this) {
      case DateFilterType.day:
        return 'يوم';
      case DateFilterType.month:
        return 'شهر';
      case DateFilterType.year:
        return 'سنة';
    }
  }
}
