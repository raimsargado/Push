class WorkSet {
  int id;
  final String set;
  final String recent;
  final String weight;
  final String reps;
  final String tag;

  WorkSet({
    this.set,
    this.recent,
    this.weight,
    this.reps,
    this.tag,
  });

  Map<String, dynamic> toMap() {
    return {
      'set': set,
      'recent': recent,
      'weight': weight,
      'reps': reps,
      'tag': tag,
    };
  }

  static WorkSet fromMap(Map<String, dynamic> map) {
    return WorkSet(
      set: map['set'],
      recent: map['recent'],
      weight: map['weight'],
      reps: map['reps'],
      tag: map['tag'],
    );
  }
}
