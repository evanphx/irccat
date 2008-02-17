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