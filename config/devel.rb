# cargar todo lo necesario para development

require 'ruby-debug'

require "sinatra/reloader"

configure do |config|
  config.also_reload "models/*.rb"
end

