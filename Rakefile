require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'

CLEAN.include("**/*.gem", "**/*.rbc", "**/*.lock")

namespace :gem do
  desc 'Build the ez-email gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = Gem::Specification.load('ez-email.gemspec')
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc "Install the ez-email package as a gem"
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

namespace :mailhog do
  desc 'Start a local mailhog server'
  task :start do
    system('docker compose up -d')
  end

  desc 'Stop the local mail server'
  task :stop do
    system('docker compose down')
  end
end

desc "Run the test suite"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-f documentation -w'
end

task :default => :spec
