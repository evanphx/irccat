require 'json'
require 'json/add/rails'

class Github < Mongrel::HttpHandler
  
  def initialize(bot, config)
    @bot = bot; @config = config
    puts "Github enabled"
  end
  
  def process(request, response)
    response.start(200) do |head,out|
      head["Content-Type"] = "text/plain"
      post = CGI.parse(request.body.read)
      json = JSON.parse(post['payload'].join(','))
      channel = @config['irc']['channel']
      branch = json['ref'].split("/").last
      commits = json['commits']

      show = commits[0,7]

      show.each do |c|
        topic = c['message'].split("\n").first
        ref =   c['id'][0,7]
        author = c['author']['name']
        if branch != "master"
          @bot.say channel, "#{topic} - #{ref} - #{author} (#{branch})"
        else
          @bot.say channel, "#{topic} - #{ref} - #{author}"
        end
      end

      if commits.size > 7
        @bot.say channel, "#{commits.size - 7} more commits"
      end
    end
  end
end
