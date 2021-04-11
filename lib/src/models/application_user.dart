class ApplicationUser {
  final String userId;
  final String email;

  ApplicationUser({this.email, this.userId});

  Map<String,dynamic> toMap(){
    return {
      'userId': userId,
      'email': email
    };
  }
}