

class Exercise {
  final String name;
  final List<dynamic> workSets;

  int id;

  //todo filter worksets items per exercise
  //todo OR embed worksets as map into exercise object

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
