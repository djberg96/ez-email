require 'rubygems'

Gem::Specification.new do |s|
  spec.name        = 'ez-email'
  spec.version     = '0.2.0'
  spec.license     = 'Apache-2.0'
  spec.summary     = 'Really easy emails'
  spec.description = 'A very simple interface for sending email'
  spec.author      = 'Daniel Berger'
  spec.email       = 'djberg96@gmail.com'
  spec.homepage    = 'https://github.com/djberg96/ez-email'
  spec.test_file   = 'test/test_ez_email.rb'
  spec.files       = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain  = Dir['certs/*']
  
  spec.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']

  spec.add_development_dependency('test-unit')

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/djberg96/ez-email',
    'bug_tracker_uri'   => 'https://github.com/djberg96/ez-email/issues',
    'changelog_uri'     => 'https://github.com/djberg96/ez-email/blob/master/CHANGES',
    'documentation_uri' => 'https://github.com/djberg96/ez-email/wiki',
    'source_code_uri'   => 'https://github.com/djberg96/ez-email',
    'wiki_uri'          => 'https://github.com/djberg96/ez-email/wiki'
  }
end
