# The TCP Server
module IrcCat
	class TcpServer
		
		def initialize(bot,config,ip='127.0.0.1',port='8080')
			@socket = TCPserver.new(ip,port)
			puts "Starting TCP (#{ip}:#{port})"
			
			loop do  
				Thread.start(@socket.accept) do |s|
					str = s.recv( 400 ) 
					sstr = str.split(/\n/)
					sstr.each do |l|
						bot.say(config['irc']['channel'],"#{l}")
					end
					s.close
			  end  # |s|
			end # loop
			
		end # initialize
		
	end # TcpServer
end # IrcCat