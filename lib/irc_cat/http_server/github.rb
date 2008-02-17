require 'json'
require 'json/add/rails'

class Github < Mongrel::HttpHandler
  
  def initialize(bot, config); @bot = bot; @config = config; puts "Github enabled"; end
  
  def process(request, response)
    response.start(200) do |head,out|
      head["Content-Type"] = "text/plain"
      post = CGI.parse(request.body.read)
      json = JSON.parse(post['payload'].join(','))
      json['commits'].each do |c|
        @bot.say(@config['irc']['channel'],"[#{json['repository']['name']}] New commit by #{c.last['author']['name']} : #{c.last['message'].gsub(/\n(.*)/, '...')} - #{c.last['url']}")
      end
    end
  end
end