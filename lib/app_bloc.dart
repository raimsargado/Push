abstract class AppBloc {
  Stream<dynamic> get valOutput;
  void valInput(dynamic any);
  void dispose();
}
