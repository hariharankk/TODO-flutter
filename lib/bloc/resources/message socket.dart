import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class message_StreamSocket{
  var _socketResponse= StreamController<List<dynamic>>();
  late IO.Socket socket;
  void Function(List<dynamic>) get addResponse => _socketResponse.sink.add;
  Stream<List<dynamic>> get getResponse => _socketResponse.stream;

  message_StreamSocket(){
    socket = IO.io('http://127.0.0.1:5000/message-get', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': false,// optional
    });
    socket.connect();

  }
  void openingapprovalconnectAndListen(String id){
    socket.emit('/message/get',id);
    socket.on('/message/get', (data) {
      addResponse(data['data']);
    });

  }

  void openingapprovaldisconnect(){
    socket.dispose();
    socket.destroy();
    socket.close();
    socket.disconnect();
  }

}