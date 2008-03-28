# This is the bot.
# Original code by Madx (yapok.org)
class H < HashWithIndifferentAccess; end;

module IrcCat
# The IRC bot
class Bot

  attr_accessor :socket, :host, :port, :nick, :channel, :nick_pass, :channel_pass
  
  # Initialize the bot with default values
  def initialize(constructor = H.new)
    @realname = "irc_cat #{IrcCat::VERSION::STRING} - http://irccat.rubyforge.org/"
    @refresh_rate = 10
    
    constructor.each do |key, val|
      if val.is_a?(String)
        instance_eval("@#{key} = '#{val}'")
      elsif val.is_a?(Array) 
        instance_eval("@#{key} = []")
        val.each do |v| instance_eval("@#{key}.push('#{v}')") end
      end
    end
    puts "Connecting to IRC #{@host}:#{@port} #{@channel}" 
  end
  
  def run
    @socket = TCPSocket.open(@host, @port)    
    login
    
    trap(:INT) {
      puts "Bye bye."
      self.sexit('God^WConsole killed me')
      sleep 1
      @socket.close
      exit
    }

    
    threads=[]
    
    threads << Thread.new {
      begin
        while line = @socket.gets do
          # Remove all formatting
          line.gsub!(/[\x02\x1f\x16\x0f]/,'')
          # Remove CTCP ASCII
          line.gsub!(/\001/,'')
          # Send to event handler
          handle line
          # Handle Pings from Server
          sendln "PONG #{$1}" if /^PING\s(.*)/ =~ line                  
        end        
      rescue EOFError
        err 'Server Reset Connection'     
      rescue Exception => e
        err e
      end
    }
    threads << Thread.new {
    }
    threads.each { |th| th.join }
    
    
  end
  
  # Announces states
  def announce(msg)
    @channels.each do |channel|
      say(channel, msg)
    end
  end
  
  # Say something funkeh
  def say(chan,msg)
    sendln "PRIVMSG #{chan} :#{msg}"
  end
  
  # Send EXIT
  def sexit(message='quit')
    sendln("QUIT :#{message}")
  end
  
  private
  
  # Sends a message to the server
  
  def sendln(cmd)
    if cmd.size <= 510      
      @socket.write("#{cmd}\r\n")
      STDOUT.flush
    else
    end
  end
  
  # Handle a received message
  
  def handle(line)
    if line =~ /^:.+\s376/
      join_channels
    elsif line =~ /^:.+KICK #([^\s]+)/
      auto_rejoin($1)
    end
  end
  
  # Automatic events
  
  def join_channels
    sendln "JOIN #{@channel} #{@channel_pass}"
  end
  
  
  def auto_rejoin(channel)
    sendln "JOIN ##{channel} #{@channel_pass}"
  end
  
  def login
    begin
      #user = @mail.split("@")
      sendln "NICK #{@nick}"     
      sendln "USER irc_cat . . :#{@realname}"
      if @nick_pass
        puts "logging in to NickServ"
        sendln "PRIVMSG NICKSERV :identify #{@nick_pass}"
      end
    rescue Exception => e
      err e
    end
  end
  
  # Loggin methods
  
  def log(str)
    $stdout.puts "DEBUG: #{str}"
  end
  
  def err(exception)
    $stderr.puts "ERROR: #{exception}"
    $stderr.puts "TRACE: #{exception.backtrace}"
  end
  
end
end