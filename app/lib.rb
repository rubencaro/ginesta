# encoding: utf-8

def show_list(params)
  erubis :list
end

def show_repo(params)
  @repo = Git.repo(params[:repo])
  erubis :repo
end

def show_tree(params)
  @repo = Git.repo(params[:repo])
  @tree = @repo.tree params[:tree]
  @commits = @repo.commits params[:tree]
  erubis :tree
end

def show_commit(params)
  @repo = Git.repo(params[:repo])
  erubis :commit
end

def show_blob(params)
  @repo = Git.repo(params[:repo])
  erubis :blob
end

def show_tag(params)
  @repo = Git.repo(params[:repo])
  erubis :tag
end

def show_branch(params)
  @repo = Git.repo(params[:repo])
  erubis :branch
end


