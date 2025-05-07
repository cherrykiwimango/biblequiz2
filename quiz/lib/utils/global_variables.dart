class GlobalUser{
  static final GlobalUser _instance = GlobalUser._internal();
  factory GlobalUser() => _instance;
  GlobalUser._internal();

  //User details
  String name = '';
  String email = '';
  int userId = 0;

  //Quiz details
  String portions = '';
  int progress = 0;
  int currentDay = 0;
  List<Map<String, dynamic>>? quiz;
  DateTime startDate = DateTime(2025, 05, 04);

  void updateFromMap(Map<String, dynamic> data) {
    userId = data['id'] ?? 0;
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