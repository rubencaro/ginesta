require 'rubygems'
require 'sinatra'
Encoding.default_external = 'utf-8'
require File.dirname(__FILE__) + "/app/main.rb"

log = File.new(File.dirname(__FILE__) + "/log/sinatra.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)
log.sync = true

# set :environment, :production
set :views, 'app/views/'

run Sinatra::Application
