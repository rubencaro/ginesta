# encoding: utf-8
$LOAD_PATH << './app'

require 'main'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

# system "rm -fr #{File.dirname(__FILE__)}/dummy_repo"

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
#     build_dummy_repo unless is_dummy_repo?
  end

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

  def is_dummy_repo?
    FileTest.exist? "#{File.dirname(__FILE__)}/dummy_repo"
  end

  # dummy repo definition for testing
  def build_dummy_repo
    clean_dummy_repo
    # unzip repo, zipped using 'zip -rq dummy_repo.zip dummy_repo'
    system "cd #{File.dirname(__FILE__)}; unzip dummy_repo.zip"
    Git.repos = {
      :dummy => File.dirname(__FILE__) + '/dummy_repo',
    }
  end

  def clean_dummy_repo
    system "rm -fr #{File.dirname(__FILE__)}/dummy_repo"
  end

end
