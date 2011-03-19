# cargar todo lo necesario para development

require 'ruby-debug'

require "sinatra/reloader"

configure do |config|
  config.also_reload "models/*.rb"
end

require 'logger'

configure do
  LOGGER = Logger.new(STDOUT)
end

# definido globalmente, como helper no es suficiente
def logger
  LOGGER
end

class ActiveRecord::Base
  def logger
    LOGGER
  end
end