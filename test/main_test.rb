# encoding: utf-8
require 'test_helper'
require 'cgi'

class MainTest < Test::Unit::TestCase

  test "gets list" do
    get '/'
    check_ok
  end

  test "gets repo" do
    get '/dummy'
    check_ok
  end

  test "gets tree" do
    pend
  end

  test "gets commit" do
    pend
  end

  test "gets tag" do
    pend
  end

  test "gets branch" do
    pend
  end

  test "gets blob" do
    pend
  end

end