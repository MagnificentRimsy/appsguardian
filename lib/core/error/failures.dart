
abstract class Failure {
  final String message;

  Failure(this.message);
}

class SomeSpecificError extends Failure {
  SomeSpecificError(String message) : super(message);
}



class ServerFailure extends Failure {
  final String message;

  ServerFailure( this.message) : super(message);

  @override
  List<Object?> get props => [message];  // Ensure it’s comparable if needed
}


