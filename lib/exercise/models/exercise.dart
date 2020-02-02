class Exercise {
  final String name;
  final String weightUnit;
  final List<dynamic> workSets;
  final int sortId;

  int id;

  Exercise({this.sortId, this.name, this.workSets, this.weightUnit});

  Map<String, dynamic> toMap() {
    return {
      'sortId': sortId,
      'name': name,
      'workSets': workSets,
      'weightUnit': weightUnit,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      sortId: map['sortId'],
      name: map['name'],
      workSets: map['workSets'],
      weightUnit: map['weightUnit'],
    );
  }
}
