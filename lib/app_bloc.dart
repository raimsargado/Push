abstract class AppBloc {
  Stream<dynamic> get valOutput;

  void valCreate(dynamic any);

  void valUpdate(dynamic any);

  void valDelete(dynamic any);

  Future<bool> valSearch(dynamic any);

  void dispose();
}
