# encoding: utf-8

def show_list
  erubis :list
end

def show_repo(params)
  @repo = Git.repo(REPOS[params[:repo].to_sym])
  erubis :repo
end

def show_tree(params)
  @repo = Git.repo(REPOS[params[:repo].to_sym])
  erubis :tree
end

def show_commit(params)
  @repo = Git.repo(REPOS[params[:repo].to_sym])
  erubis :commit
end

def show_blob(params)
  @repo = Git.repo(REPOS[params[:repo].to_sym])
  erubis :blob
end

def show_tag(params)
  @repo = Git.repo(REPOS[params[:repo].to_sym])
  erubis :tag
end

def show_branch(params)
  @repo = Git.repo(REPOS[params[:repo].to_sym])
  erubis :branch
end