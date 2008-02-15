# The HTTP Server

require 'json'
require 'json/add/rails'

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

class Github < Mongrel::HttpHandler
  
  def initialize(bot, config); @bot = bot; @config = config; puts "Github enabled"; end
  
  def process(request, response)
    response.start(200) do |head,out|
      head["Content-Type"] = "text/plain"
      js = CGI.parse(request.body.read)
      json = JSON.parse(js['payload'].join(','))
      json['commits'].each do |c|
        @bot.say(@config['irc']['channel'],"[#{json['repository']['name']}] New commit by #{c.last['author']['name']} : #{c.last['message'].gsub(/\n(.*)/, '...')} - #{c.last['url']}")
      end
    end
  end
end

module IrcCat
	class HttpServer
		def initialize(bot, config, ip, port)
			@bot = bot
			@config = config
			puts "Starting HTTP (#{ip}:#{port})"
			h = Mongrel::HttpServer.new(ip, port)
			h.register("/", Index.new)
			h.register("/send", Send.new(@bot, @config))
			h.register("/github", Github.new(@bot, @config)) if @config['http']['github'] == true
			h.run.join
		end
	end # HttpServer
end # IrcCat