# -*- encoding: utf-8 -*-

require 'rake'

Gem::Specification.new do |s|
  s.name = %q{marshalize}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors           = "Jean-Denis Vauguet"
  s.date              = %q{2009-07-27}
  s.summary           = %q{Marshalize is a Rails plugin enabling ActiveRecord attributes serialization using the Marshal binary converter library.}
  s.description       = %q{Grit is a Ruby library for extracting information from a git repository in an object oriented manner.}
  s.email             = %q{jd@vauguet.fr}
  s.files             = FileList['[A-Z]*', 'rails/**/*.rb', 'lib/**/*.rb', 'test/**/*', 'generators/**/*'].to_a
  s.has_rdoc          = true
  s.homepage          = %q{http://github.com/chikamichi/marshalize}
  s.rdoc_options      = ["--inline-source", "--charset=UTF-8"]
  s.extra_rdoc_files  = ["README.md", "COPYING", "ChangeLog.md"]
  s.rubygems_version  = %q{1.3.1}
  s.test_files        = ["test/marshalize_test.rb"]
  spec.rdoc_options << '--title' << 'Marshalize -- serialization using Marshal' << '-FNS' << '-w 2' << '-a'

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
 
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<git>, [">= 1.1.1"])
      s.add_runtime_dependency(%q<rubyforge>, [">= 0"])
    else
      s.add_dependency(%q<git>, [">= 1.1.1"])
      s.add_dependency(%q<rubyforge>, [">= 0"])
    end
  else
    s.add_dependency(%q<git>, [">= 1.1.1"])
    s.add_dependency(%q<rubyforge>, [">= 0"])
  end
end

