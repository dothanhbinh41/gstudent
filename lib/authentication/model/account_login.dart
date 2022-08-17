 class AccountLogin{
  String email;
  AccountLogin({this.email});

  factory AccountLogin.fromJson(Map<String, dynamic> json) => AccountLogin(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };

}