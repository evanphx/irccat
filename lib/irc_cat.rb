$:.unshift File.dirname(__FILE__)
@config = {"tcp"=>{"port"=>"5678", "enabled"=>true, "host"=>"0.0.0.0"}, 
           "irc"=>{"nick"=>"irc_cat", "port"=>"6667", "channel"=>"#irc_cat", "host"=>"irc.example.com"}, 
           "http"=>{"github"=>true, "port"=>"3489", "enabled"=>true, "send"=>true, "host"=>"0.0.0.0"}} if @config.nil?
require 'rubygems'
require 'irc_cat/indifferent_access'
require 'socket'
require 'irc_cat/version'
require 'irc_cat/bot'
require 'irc_cat/tcp_server'
require 'irc_cat/http_server'