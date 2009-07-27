require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the marshalize plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

#desc 'Generate documentation for the marshalize plugin.'
#Rake::RDocTask.new(:rdoc) do |rdoc|
  #rdoc.rdoc_dir = 'rdoc'
  #rdoc.title    = 'Marshalize'
  #rdoc.options '--title' << 'Marshalize -- serialization using Marshal' << '-FNS' << '-w 2' << '-a'
  #rdoc.rdoc_files.include('README')
  #rdoc.rdoc_files.include('lib/**/*.rb')
#end
