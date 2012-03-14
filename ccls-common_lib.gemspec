# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ccls-common_lib}
  s.version = "0.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["George 'Jake' Wendt"]
  s.date = %q{2012-03-14}
  s.description = %q{CCLS Common Lib gem}
  s.email = %q{github@jakewendt.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "generators/ccls_common_lib/USAGE",
    "generators/ccls_common_lib/ccls_common_lib_generator.rb",
    "generators/ccls_common_lib/templates/autotest_common_lib.rb",
    "generators/ccls_common_lib/templates/common_lib.rake",
    "generators/ccls_common_lib/templates/javascripts/common_lib.js",
    "generators/ccls_common_lib/templates/stylesheets/common_lib.css",
    "lib/ccls-common_lib.rb",
    "lib/common_lib.rb",
    "lib/common_lib/action_controller_extension.rb",
    "lib/common_lib/action_controller_extension/accessible_via_format.rb",
    "lib/common_lib/action_controller_extension/accessible_via_protocol.rb",
    "lib/common_lib/action_controller_extension/accessible_via_user.rb",
    "lib/common_lib/action_controller_extension/routing.rb",
    "lib/common_lib/action_controller_extension/test_case.rb",
    "lib/common_lib/action_view_extension.rb",
    "lib/common_lib/action_view_extension/base.rb",
    "lib/common_lib/action_view_extension/form_builder.rb",
    "lib/common_lib/active_record_extension.rb",
    "lib/common_lib/active_record_extension/base.rb",
    "lib/common_lib/active_record_extension/error.rb",
    "lib/common_lib/active_record_extension/errors.rb",
    "lib/common_lib/active_support_extension.rb",
    "lib/common_lib/active_support_extension/associations.rb",
    "lib/common_lib/active_support_extension/attributes.rb",
    "lib/common_lib/active_support_extension/pending.rb",
    "lib/common_lib/active_support_extension/test_case.rb",
    "lib/common_lib/array_extension.rb",
    "lib/common_lib/autotest.rb",
    "lib/common_lib/factories.rb",
    "lib/common_lib/hash_extension.rb",
    "lib/common_lib/integer_extension.rb",
    "lib/common_lib/nil_class_extension.rb",
    "lib/common_lib/object_extension.rb",
    "lib/common_lib/string_extension.rb",
    "lib/common_lib/tasks.rb",
    "lib/common_lib/test_tasks.rb",
    "lib/tasks/database.rake",
    "lib/tasks/rcov.rake",
    "rails/init.rb"
  ]
  s.homepage = %q{http://github.com/ccls/common_lib}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{CCLS Common Lib gem}
  s.test_files = ["test/unit/common_lib/array_extension_test.rb", "test/unit/common_lib/hash_extension_test.rb", "test/unit/common_lib/integer_extension_test.rb", "test/unit/common_lib/nil_class_extension_test.rb", "test/unit/common_lib/object_extension_test.rb", "test/unit/common_lib/string_extension_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 2"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 2"])
      s.add_runtime_dependency(%q<activeresource>, ["~> 2"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 2"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 2"])
      s.add_runtime_dependency(%q<ryanb-acts-as-list>, [">= 0"])
      s.add_runtime_dependency(%q<ssl_requirement>, [">= 0.1.0"])
    else
      s.add_dependency(%q<rails>, ["~> 2"])
      s.add_dependency(%q<activerecord>, ["~> 2"])
      s.add_dependency(%q<activeresource>, ["~> 2"])
      s.add_dependency(%q<activesupport>, ["~> 2"])
      s.add_dependency(%q<actionpack>, ["~> 2"])
      s.add_dependency(%q<ryanb-acts-as-list>, [">= 0"])
      s.add_dependency(%q<ssl_requirement>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 2"])
    s.add_dependency(%q<activerecord>, ["~> 2"])
    s.add_dependency(%q<activeresource>, ["~> 2"])
    s.add_dependency(%q<activesupport>, ["~> 2"])
    s.add_dependency(%q<actionpack>, ["~> 2"])
    s.add_dependency(%q<ryanb-acts-as-list>, [">= 0"])
    s.add_dependency(%q<ssl_requirement>, [">= 0.1.0"])
  end
end

