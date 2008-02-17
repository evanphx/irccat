require 'yaml'

@config = YAML.load_file( 'config.yml' )

require 'lib/irc_cat'