
import 'dart:convert';

class SignupModel {
  final String message;

  SignupModel( 
    {
      required this.message,
    }
    
  );

  SignupModel copyWith({
    String? message,
  }) {
    return SignupModel(
      message: message ?? this.message
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'message': message
    };
  }

  factory SignupModel.fromMap(Map<String, dynamic> map) {
    return SignupModel(
      message: map["message"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SignupModel.fromJson(String source) => SignupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override 
  String toString() => 'SignupModel(message: $message)';

  @override 
  bool operator == (covariant SignupModel other) {
   if (identical(this, other)) return true; 

   return other.message == message;
  }

  @override 
  int get hashCode => message.hashCode;

  
}