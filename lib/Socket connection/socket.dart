import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class Socket {
  static final  IO.Socket socket = IO.io(
      "http://192.168.1.14:4000/",
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

          
}
