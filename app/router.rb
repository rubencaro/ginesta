# encoding: utf-8

get '/' do
  show_list params
end

get '/:repo' do
  show_repo params
end

get '/:repo/tree/:tree' do
  show_tree params
end

get '/:repo/commit/:commit' do
  show_commit params
end

get '/:repo/blob/:blob' do
  show_blob params
end

get '/:repo/tag/:tag' do
  show_tag params
end

get '/:repo/branch/:branch' do
  show_branch params
end
