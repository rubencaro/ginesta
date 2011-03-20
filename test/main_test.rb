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
    get '/dummy/commit/dbfe5bb026645d05aea4a3c3e4f8f33bd0423da3'
    check_ok
  end

  test "gets tag" do
    get '/dummy/tag/0.1'
    check_ok
  end

  test "gets branch" do
    get '/dummy/branch/master'
    check_ok
  end

  test "gets blob" do
    pend
  end

end