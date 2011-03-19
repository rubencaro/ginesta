# encoding: utf-8
require 'grit'

module Git

  def self.repo(path)
    Grit::Repo.new(path)
  end

end
