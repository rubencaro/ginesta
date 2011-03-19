$LOAD_PATH << './app'

require 'main'
# require 'capybara'
# require 'capybara/dsl'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

# require 'test_notifier/runner/test_unit'
# TestNotifier.default_notifier = :notify_send

# # Capybara.app = Sinatra::Application.new
# Capybara.run_server = true #Whether start server when testing
# Capybara.default_selector = :css #default selector , you can change to :css
# Capybara.default_wait_time = 2 #When we testing AJAX, we can set a default wait time
# Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
# #Capybara.javascript_driver = :rack_test  #default driver when you using @javascript tag
# #Capybara.default_driver = :rack_test


class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

#   include Capybara
  # Capybara.default_driver = :selenium # <-- use Selenium driver

#   def setup
#     Capybara.app = Sinatra::Application.new
#   end

end