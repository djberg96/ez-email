require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include("**/*.gem", "**/*.rbc")

namespace :gem do
  desc 'Build the ez-email gem'
  task :create => [:clean] do
    spec = eval(IO.read('ez-email.gemspec'))
    Gem::Builder.new(spec).build
  end

  desc "Install the ez-email package as a gem"
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install #{file}"
  end
end

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
end

task :default => :test
