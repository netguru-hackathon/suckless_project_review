#!/usr/bin/env ruby

require 'date'

def say(what)
  command = "figlet #{what}"
  system command
end

git = `git shortlog --since='4 weeks ago' -n -s`
git_spec = `git shortlog --since='4 weeks ago' -n -s -p spec/`
#[[12, 'autor'],[23, 'autor2']]
commits_author = git.split("\n").map { |x| x.split }
commits_spec_author = git_spec.split("\n").map { |x| x.split }


commits_sum = commits_author.map { |row| row.first.to_i }.reduce(&:+)
commits__spec_sum = commits_spec_author.map { |row| row.first.to_i }.reduce(&:+)

rails_version = `bundle show rails`.split('/').last.chop
ruby_version = `ruby -v`

puts "Suckless Project Review 6.66"
puts "Ruby version: #{ruby_version}"
puts "Rails version: #{rails_version}"
say "TOO OLD" if rails_version.split('-').last[0].to_i < 4

puts "\nCommits:"
commits_author.each { |x| puts "#{x[0]} #{x[1..-1].join(' ')}" }

puts "\n\nCommits that touched specs"
commits_spec_author.each { |x| puts "#{x[0]} #{x[1..-1].join(' ')}" }

production_dep = `git checkout production &> /dev/null; git log -n1 | grep Date`
production_dep_date = Date.parse(production_dep)
`git checkout master &> /dev/null`

puts "\nLast deployment: "
puts production_dep_date

say "TOO OLD" if production_dep_date < Date.today - 14 

