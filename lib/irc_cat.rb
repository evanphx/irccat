require 'rubygems'
require 'lib/irc_cat/indifferent_access'
require 'socket'
require 'mongrel'
require 'lib/irc_cat/bot'
require 'lib/irc_cat/tcp_server'
require 'lib/irc_cat/http_server'

threads = []

Thread.new {
@bot = IrcCat::Bot.new(:host => @config['irc']['host'], :port => @config['irc']['port'], 
	:nick => @config['irc']['nick'], :channel => @config['irc']['channel'])
}

Thread.new {
	@tcp = IrcCat::TcpServer.new(@bot, @config, @config['tcp']['host'], @config['tcp']['port'])
}

Thread.new {
	@http = IrcCat::HttpServer.new(@bot, @config, @config['http']['host'], @config['http']['port'])
}


@bot.run