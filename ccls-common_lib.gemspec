# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ccls-common_lib}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["George 'Jake' Wendt"]
  s.date = %q{2011-09-26}
  s.description = %q{CCLS Common Lib gem}
  s.email = %q{github@jakewendt.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "Rakefile",
    "VERSION"
  ]
  s.homepage = %q{http://github.com/ccls/common_lib}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{CCLS Common Lib gem}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 2"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 2"])
      s.add_runtime_dependency(%q<activeresource>, ["~> 2"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 2"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 2"])
    else
      s.add_dependency(%q<rails>, ["~> 2"])
      s.add_dependency(%q<activerecord>, ["~> 2"])
      s.add_dependency(%q<activeresource>, ["~> 2"])
      s.add_dependency(%q<activesupport>, ["~> 2"])
      s.add_dependency(%q<actionpack>, ["~> 2"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 2"])
    s.add_dependency(%q<activerecord>, ["~> 2"])
    s.add_dependency(%q<activeresource>, ["~> 2"])
    s.add_dependency(%q<activesupport>, ["~> 2"])
    s.add_dependency(%q<actionpack>, ["~> 2"])
  end
end

