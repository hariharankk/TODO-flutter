import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';


class Message extends Equatable {
  String message;
  String sender;
  String timeCreated;
  String subtaskKey;
  String messageKey;


  Message({required this.message, required this.timeCreated, required this.sender,required this.subtaskKey, required this.messageKey});

  factory Message.fromJson(Map<String, dynamic> parsedJson) {
    return Message(
      message: parsedJson['message'],
      sender: parsedJson['sender'],
      subtaskKey: parsedJson['subtaskKey'],
      messageKey: parsedJson['messageKey'],
      timeCreated: parsedJson['time_created'],
    );
  }

  @override
  List<Object> get props => [sender];

  @override
  String toString() {
    return "message: $message, sender: ${sender}";
  }


}
