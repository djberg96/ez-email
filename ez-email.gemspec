require 'rubygems'

Gem::Specification.new do |spec|
  spec.name        = 'ez-email'
  spec.version     = '0.3.0'
  spec.license     = 'Apache-2.0'
  spec.summary     = 'Really easy emails'
  spec.description = 'A very simple interface for sending email'
  spec.author      = 'Daniel Berger'
  spec.email       = 'djberg96@gmail.com'
  spec.homepage    = 'https://github.com/djberg96/ez-email'
  spec.test_file   = 'spec/ez_email_spec.rb'
  spec.files       = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain  = Dir['certs/*']
  
  spec.extra_rdoc_files  = ['README.md', 'CHANGES.md', 'MANIFEST.md']

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.9')

  spec.metadata = {
    'homepage_uri'          => 'https://github.com/djberg96/ez-email',
    'bug_tracker_uri'       => 'https://github.com/djberg96/ez-email/issues',
    'changelog_uri'         => 'https://github.com/djberg96/ez-email/blob/main/CHANGES.md',
    'documentation_uri'     => 'https://github.com/djberg96/ez-email/wiki',
    'source_code_uri'       => 'https://github.com/djberg96/ez-email',
    'wiki_uri'              => 'https://github.com/djberg96/ez-email/wiki',
    'github_repo'           => 'https://github.com/djberg96/attempt',
    'funding_uri'           => 'https://github.com/sponsors/djberg96',
    'rubygems_mfa_required' => 'true'
  }
end
