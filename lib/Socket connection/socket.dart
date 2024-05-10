import 'package:socket_io_client/socket_io_client.dart' as IO;


class Socket {
  static final  IO.Socket socket = IO.io(
      "http://192.168.1.6:4000/",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setTimeout(200000)
          .build()
          );

          
}
