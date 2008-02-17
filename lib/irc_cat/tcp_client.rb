require 'socket'
module IrcCat
  class TcpClient
    def self.notify(ip,port,message)
      socket = TCPSocket.open(ip,port)
      socket.write(message + "\r\n")
    end
  end
end