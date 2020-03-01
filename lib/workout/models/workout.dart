class Workout {
  int id;
  final String name;
  final String startTime;
  final int sortId;

//  final List<Exercise> exercise;

  Workout(this.name, this.startTime, this.sortId);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime,
      'sortId': sortId,
    };
  }

  static Workout fromMap(Map<String, dynamic> map) {
    return Workout(
      map['name'],
      map['startTime'],
      map['sortId'],
    );
  }
}
