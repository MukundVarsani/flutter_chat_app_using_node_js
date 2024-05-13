// ignore_for_file: library_prefixes

import 'package:socket_io_client/socket_io_client.dart' as iO;


class Socket {
  static final iO.Socket socket = iO.io(
      "http://192.168.1.5:4000/",
      iO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setTimeout(200000)
          .build()
          );

          
}
