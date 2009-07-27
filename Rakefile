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

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "marshalize"
    gemspec.summary     = %q{Marshalize is a Rails plugin enabling ActiveRecord attributes serialization using the Marshal binary converter library.}
    gemspec.description = %q{This Rails plugin provides serialization using Marshal in the same way Rails provides builtin serialization using YAML. You can register any kind object (not just arrays and hashes…). Be aware that Marshal defines a binary format, which may change in incoming Ruby releases and is currently not portable outside the Ruby scripting world. For a portable yet slower alternatives, you may try JSON or YML serializers.}
    gemspec.email       = "jd@vauguet.fr"
    gemspec.homepage    = "http://github.com/chikamichi/marshalize"
    gemspec.authors =   ["Jean-Denis Vauguet"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

