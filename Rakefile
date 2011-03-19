# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'

rake_list = FileList['lib/**/*.rake']
rake_list.each do |item|
  load "#{item}"
end
