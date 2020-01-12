

class Exercise {
  final String name;
  final List<dynamic> workSets;

  int id;

  Exercise(this.name, this.workSets);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'workSets': workSets,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      map['name'],
      map['workSets'],
    );
  }
}
