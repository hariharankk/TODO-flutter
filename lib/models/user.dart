 import 'package:todolist/models/groupmember.dart';
//import 'package:todolist/models/group.dart';

// ignore: must_be_immutable
class User extends GroupMember {


  User.blank(): super.blank();

  User(
      {username, firstname, lastname, emailaddress, phonenumber, avatar})
      : super(
            username: username,
            emailaddress: emailaddress,
            phonenumber: phonenumber,
  );

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      username: parsedJson['username'],
      emailaddress: parsedJson['emailaddress'],
      firstname: parsedJson['firstname'],
      lastname: parsedJson['lastname'],
      phonenumber: parsedJson['phonenumber'],
    );
  }
  @override
  List<Object> get props => [username];

  @override
  String toString() {
    return username;
  }
}
