class WorkSet {
  int id;
  final String previous;
  final String weight;
  final String reps;
  final String tag;

  WorkSet({
    this.previous,
    this.weight,
    this.reps,
    this.tag,
  });

  Map<String, dynamic> toMap() {
    return {
      'previous': previous,
      'weight': weight,
      'reps': reps,
      'tag': tag,
    };
  }

  static WorkSet fromMap(Map<String, dynamic> map) {
    return WorkSet(
      previous: map['previous'],
      weight: map['weight'],
      reps: map['reps'],
      tag: map['tag'],
    );
  }
}
