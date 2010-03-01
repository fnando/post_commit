# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{post_commit}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nando Vieira"]
  s.date = %q{2010-03-01}
  s.description = %q{Five services are supported for now: Basecamp, Campfire, FriendFeed, LightHouse and Twitter.}
  s.email = %q{fnando.vieira@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "CHANGELOG.rdoc",
     "README.rdoc",
     "lib/post_commit.rb",
     "lib/post_commit/errors.rb",
     "lib/post_commit/hooks.rb",
     "lib/post_commit/hooks/base.rb",
     "lib/post_commit/hooks/basecamp.rb",
     "lib/post_commit/hooks/campfire.rb",
     "lib/post_commit/hooks/friend_feed.rb",
     "lib/post_commit/hooks/light_house.rb",
     "lib/post_commit/hooks/twitter.rb",
     "lib/post_commit/version.rb",
     "spec/post_commit/base_spec.rb",
     "spec/post_commit/basecamp_spec.rb",
     "spec/post_commit/campfire_spec.rb",
     "spec/post_commit/friend_feed_spec.rb",
     "spec/post_commit/light_house_spec.rb",
     "spec/post_commit/twitter_spec.rb",
     "spec/resources/controllers.rb",
     "spec/resources/responses/campfire.json",
     "spec/resources/responses/friendfeed.json",
     "spec/resources/responses/lighthouse.json",
     "spec/resources/responses/twitter.json",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/fnando/post_commit}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Post commit allows you to notify several services with simple and elegant DSL}
  s.test_files = [
    "spec/post_commit/base_spec.rb",
     "spec/post_commit/basecamp_spec.rb",
     "spec/post_commit/campfire_spec.rb",
     "spec/post_commit/friend_feed_spec.rb",
     "spec/post_commit/light_house_spec.rb",
     "spec/post_commit/twitter_spec.rb",
     "spec/resources/controllers.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
  end
end

