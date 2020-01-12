

class Exercise {
  final String name;
  final String weightUnit;
  final List<dynamic> workSets;

  int id;

  Exercise({this.name, this.workSets, this.weightUnit});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'workSets': workSets,
      'weightUnit': weightUnit,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
     name: map['name'],
      workSets: map['workSets'],
      weightUnit: map['weightUnit'],
    );
  }
}
