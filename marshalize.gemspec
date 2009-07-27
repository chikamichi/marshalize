# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{marshalize}
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jean-Denis Vauguet"]
  s.date = %q{2009-07-27}
  s.description = %q{This Rails plugin provides serialization using Marshal in the same way Rails provides builtin serialization using YAML. You can register any kind object (not just arrays and hashes…). Be aware that Marshal defines a binary format, which may change in incoming Ruby releases and is currently not portable outside the Ruby scripting world. For a portable yet slower alternatives, you may try JSON or YML serializers.}
  s.email = %q{jd@vauguet.fr}
  s.extra_rdoc_files = [
    "ChangeLog.rdoc",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "COPYING",
     "ChangeLog.rdoc",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "generators/marshalize/USAGE",
     "generators/marshalize/marshalize_generator.rb",
     "init.rb",
     "install.rb",
     "lib/marshalize.rb",
     "rails/init.rb",
     "test/database.yml",
     "test/marshalize_test.rb",
     "test/schema.rb",
     "test/test_helper.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/chikamichi/marshalize}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Marshalize is a Rails plugin enabling ActiveRecord attributes serialization using the Marshal binary converter library.}
  s.test_files = [
    "test/schema.rb",
     "test/marshalize_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
