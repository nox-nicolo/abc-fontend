// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppFailure {
  AppFailure( 
    [
      this.message = "Sorry an unexpected error occured!", 
    ]
  ); 

  final String message;

  @override
  String toString() => 'AppFailure(message: $message)';
}
