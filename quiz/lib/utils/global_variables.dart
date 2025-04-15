class GlobalUser{
  static final GlobalUser _instance = GlobalUser._internal();
  factory GlobalUser() => _instance;
  GlobalUser._internal();

  String name = '';
  String email = '';
  String portions = '';
  int progress = 0;
  int currentDay = 0;
  DateTime startDate = DateTime(2025, 04, 13);

  void updateFromMap(Map<String, dynamic> data) {
    name = data['user_name'] ?? '';
    email = data['user_email'] ?? '';
    progress = data['progress'] ?? 0;//not sure if this will bite me in the butt later
    print(data['progress']);
    print(progress);
  }

  void updateCurrentDay(){
    final currentDate = DateTime.now();
    currentDay = currentDate.difference(startDate).inDays + 1;
  }
}