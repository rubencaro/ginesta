# encoding: utf-8
require 'git'

Git.repos = {
  :admanlytics => '/home/rub/Documentos/codigo/admanlytics/admanlytics',
  :admansupercore => '/home/rub/Documentos/codigo/admansupercore/admansupercore',
  :gitree => '/home/rub/Documentos/codigo/gitree',
  :ginesta => '/home/rub/Documentos/codigo/ginesta/ginesta',
  :dummy => '/home/rub/Documentos/codigo/ginesta/ginesta/test/dummy_repo',
}

require 'logger'

configure do
  LOGGER = Logger.new(STDOUT)
end

# definido globalmente, como helper no es suficiente
def logger
  LOGGER
end

# stolen from https://gist.github.com/119874
module Sinatra::Partials
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << erb(:"#{template}", options.merge(:layout =>
        false, :locals => {template_array[-1].to_sym => member}))
      end.join("\n")
    else
      erubis(:"#{template}", options)
    end
  end
end

helpers Sinatra::Partials
