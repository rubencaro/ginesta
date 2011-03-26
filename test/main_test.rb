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
    get '/dummy/tree/master'
    check_ok
  end

  test "gets commit" do
    get '/dummy/commit/93501210aba004961d71606ca3a5d350dcfcdff5'
    check_ok
  end

  test "gets tag" do
    get '/dummy/tag/b7f05c5af257179b345365e6e0a446699096fa9e'
    check_ok
  end

  test "gets branch" do
    get '/dummy/branch/master'
    check_ok
  end

  test "gets blob" do
    get '/dummy/blob/2f1ae6c4e8d472f28a8216f76e08a5c8aebddae8'
    check_ok
  end

end