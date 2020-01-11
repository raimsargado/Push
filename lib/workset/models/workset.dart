class WorkSet {
  int id;
  final String set;
  final String previous;
  final String weight;
  final String reps;
  final String tag;

  WorkSet({
    this.set,
    this.previous,
    this.weight,
    this.reps,
    this.tag,
  });

  Map<String, dynamic> toMap() {
    return {
      'set': set,
      'previous': previous,
      'weight': weight,
      'reps': reps,
      'tag': tag,
    };
  }

  static WorkSet fromMap(Map<String, dynamic> map) {
    return WorkSet(
      set: map['set'],
      previous: map['previous'],
      weight: map['weight'],
      reps: map['reps'],
      tag: map['tag'],
    );
  }
}
