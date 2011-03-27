# encoding: utf-8
$LOAD_PATH << './app'
$LOAD_PATH << './config'
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erubis'
require 'env' # some general settings
require 'devel' if settings.environment == :development # development settings
require 'git'
require 'router'

def show_list(params)
  erubis :list
end

def show_repo(params)
  @repo_name = params[:repo]
  @repo = Git.repo(@repo_name)
  @commits = @repo.commits
  @tree = @repo.tree
  erubis :repo
end

def show_tree(params)
  @repo_name = params[:repo]
  @repo = Git.repo(@repo_name)
  @tree = @repo.tree params[:tree]
  @commits = @repo.commits params[:tree]
  erubis :tree
end

def show_commit(params)
  @repo_name = params[:repo]
  @repo = Git.repo(@repo_name)
  erubis :commit
end

def show_blob(params)
  @repo_name = params[:repo]
  @repo = Git.repo(@repo_name)
  erubis :blob
end

def show_tag(params)
  @repo_name = params[:repo]
  @repo = Git.repo(@repo_name)
  erubis :tag
end

def show_branch(params)
  @repo_name = params[:repo]
  @repo = Git.repo(@repo_name)
  @commits = @repo.commits params[:branch]
  erubis :branch
end
