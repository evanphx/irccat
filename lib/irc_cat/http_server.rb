# The HTTP Server

class Index < Mongrel::HttpHandler
	def process(request, response)
		response.start(200) do |head,out|
			head["Content-Type"] = "text/html"
			out.write("<strong>Welcome to irc_cat</strong><br /><br />This irc_cat is ready to use:) Just send a GET to : <code>/send/your message</code>.<br /><br />byekthx")
		end
	end
end

class Send < Mongrel::HttpHandler

	def initialize(bot, config); @bot = bot; @config = config; end

	def process(request, response)
		response.start(200) do |head,out|
			head["Content-Type"] = "text/plain"
			message = CGI::unescape("#{request.params['PATH_INFO'].gsub('/','')}")
			@bot.say(@config['irc']['channel'],"#{message}")
		end
	end
end

module IrcCat
	class HttpServer
		def initialize(bot, config, host, ip)
			@bot = bot
			@config = config
			h = Mongrel::HttpServer.new(host, ip)
			h.register("/", Index.new)
			h.register("/send", Send.new(@bot, @config))
			h.run.join
			
			puts "I has Mongrel.!1"
		end
	end # HttpServer
end # IrcCat