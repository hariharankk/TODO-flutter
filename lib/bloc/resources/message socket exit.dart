import 'package:socket_io_client/socket_io_client.dart' as IO;

class messageExitSocket {
  late IO.Socket socket;
  messageExitSocket() {
    socket = IO.io('http://127.0.0.1:5000/message-disconnect', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();
  }
  void Stopthread(){
    socket.emit('/message/stop_thread');
  }
}