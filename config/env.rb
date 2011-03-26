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


