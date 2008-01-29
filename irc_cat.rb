#require 'rubygems'
#require 'daemons'
#Daemons.run('lib/acts_as_ircd.rb')

require 'yaml'

@config = YAML.load_file( 'config.yml' )

require 'lib/irc_cat'