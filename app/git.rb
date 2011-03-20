# encoding: utf-8
require 'grit'

module Git

  def self.repos
    @@repos
  end

  def self.repos=(newrepos)
    @@repos=newrepos
  end

  def self.repo(repo)
    Grit::Repo.new(Git.repos[repo.to_sym])
  end

end
