# encoding: utf-8
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

# dummy repo for testing
REPOS = {
  :dummy => File.dirname(__FILE__) + '/dummy_repo',
}

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

  def check_is_json
    assert last_response.headers['Content-Type'] =~ /application\/json/
    data = JSON.parse(last_response.body)
    assert !data.nil?, 'deben ser datos json'
    data
  end

  def check_ok
    assert (last_response.status == 200 or last_response.status == 304), "debería ser status 200 o 304, pero es status=#{last_response.status}" # \n-------------response body: #{last_response.body}\n-----------------"
  end

  def check_redirection
    assert_equal 302,last_response.status
  end

end