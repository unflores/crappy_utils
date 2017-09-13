# Call it from your current project. It will find all of the coffee files
# in your project in all remote open branches, and remove them from a list
# of existing coffee files. That way you can modernize those remaining to
# typescript without stepping on the feet of other developers
branches = `git branch -r`.split("\n").
              map(&:strip).
              reject{|item| item['HEAD'] }

all_modified_files = []

branches.each do |branch|
  modified_files = `git diff --name-only #{branch} $(git merge-base #{branch} master) |grep -v build |grep -v node_modules| grep "\.coffee"`
  modified_files = modified_files.split("\n").reject{|file| file['build/']}
  all_modified_files << modified_files
end

all_modified_files = all_modified_files.flatten.uniq

all_coffee_files = `find src/ -iname '*.coffee'`.split("\n").map{|file| file.gsub('//','/') }

modifiable_files = all_coffee_files - all_modified_files

puts modifiable_files
