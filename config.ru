require 'rubygems'
require 'sinatra'
# require 'app/main.rb'
Encoding.default_external = 'utf-8'
require File.dirname(__FILE__) + "/app/main.rb"

log = File.new("log/sinatra.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)
log.sync = true

# set :environment, :production
set :views, 'app/views/'

run Sinatra::Application
