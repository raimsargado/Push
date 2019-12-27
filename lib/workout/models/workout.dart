

class Workout {
  int id;
  final String name;

//  final List<Exercise> exercise;

  Workout(this.name);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
//      'isSweet': isSweet,
    };
  }

  static Workout fromMap(Map<String, dynamic> map) {
    return Workout(map['name']);
  }
}
