# encoding: utf-8
require 'test_helper'
require 'cgi'

class MainTest < Test::Unit::TestCase

  test "test goes ok" do
    assert true
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

  def check_is_default(data)
    assert data['user']['is_default']==true, 'debe usar el default_user'
  end

  def check_not_default(data)
    assert data['user']['is_default']==false, 'no debe usar el default_user'
  end

end