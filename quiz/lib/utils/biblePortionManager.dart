class BiblePortionManager{
  static final DateTime startDate = DateTime(2025, 4, 13);

  static final Map<String, String> portionsJson = {
    '1':'Genesis 1-5',
    '2':'Genesis 6-10',
    '3':'Genesis 11-15',
    '4':'Genesis 16-20',
  };

  static int calculateDay([DateTime? currentDate]){
    final now = currentDate ?? DateTime.now();
    final day = now.difference(startDate).inDays + 1;
    return day;
  }

  static String portionForDay(int day){
    return portionsJson['$day'] ?? 'No portions found for this day';
  }

  static String portionsForDate(DateTime currentDate){
    final day = calculateDay(currentDate);
    return portionsJson['$day'] ?? "No portions found for this day";
  }

  static String portionsForToday(){
    final day = calculateDay();
    return portionsJson['$day'] ?? "No portions found for this day";
  }
}