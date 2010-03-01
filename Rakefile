require "rake"
require "hanna/rdoctask"
require "spec/rake/spectask"
require "jeweler"
require "lib/post_commit/version"

desc "Default: run specs."
task :default => :spec

desc "Run the specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ["--colour --format specdoc --loadby mtime --reverse"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.rcov_opts = ["--sort coverage", "--exclude .renv,.bundle,helper,errors.rb"]
  t.rcov = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "doc"
  rdoc.title = "Post Commit"
  rdoc.options += %w[ --line-numbers --inline-source --charset utf-8 ]
  rdoc.rdoc_files.include("README.rdoc", "CHANGELOG.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

JEWEL = Jeweler::Tasks.new do |gem|
  gem.name = "post_commit"
  gem.email = "fnando.vieira@gmail.com"
  gem.homepage = "http://github.com/fnando/post_commit"
  gem.authors = ["Nando Vieira"]
  gem.version = PostCommit::Version::STRING
  gem.summary = "Post commit allows you to notify several services with simple and elegant DSL"
  gem.description = "Five services are supported for now: Basecamp, Campfire, FriendFeed, LightHouse and Twitter."
  gem.add_dependency "json"
  gem.files =  FileList["{README,CHANGELOG}.rdoc", "{lib,spec}/**/*"]
end

Jeweler::GemcutterTasks.new
