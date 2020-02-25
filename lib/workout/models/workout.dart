class Workout {
  int id;
  final String name;
  final String startTime;

//  final List<Exercise> exercise;

  Workout(this.name, this.startTime);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime,
    };
  }

  static Workout fromMap(Map<String, dynamic> map) {
    return Workout(
      map['name'],
      map['startTime'],
    );
  }
}
