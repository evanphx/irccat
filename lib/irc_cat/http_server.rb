# The HTTP Server

require 'mongrel'
require 'irc_cat/http_server/send' if @config['http']['send']
require 'irc_cat/http_server/github' if @config['http']['github']

class Index < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |head,out|
      head["Content-Type"] = "text/html"
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
      h.register("/send", Send.new(@bot, @config)) if @config['http']['send']
      h.register("/github", Github.new(@bot, @config)) if @config['http']['github']
      h.run.join
    end
  end # HttpServer
end # IrcCat