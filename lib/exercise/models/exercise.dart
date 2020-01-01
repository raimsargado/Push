class Exercise {
  final String name;
  int id;

  Exercise(this.name);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
//      'isSweet': isSweet,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(map['name']);
  }
}
