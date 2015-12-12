require 'rubygems'

Gem::Specification.new do |s|
  s.name        = 'ez-email'
  s.version     = '0.1.5'
  s.license     = 'Artistic 2.0'
  s.summary     = 'Really easy emails'
  s.description = 'A very simple interface for sending email'
  s.author      = 'Daniel Berger'
  s.email       = 'djberg96@gmail.com'
  s.homepage    = 'https://github.com/djberg96/ez-email'
  s.test_file   = 'test/test_ez_email.rb'
  s.files       = Dir['**/*'].reject{ |f| f.include?('git') }
  s.cert_chain  = Dir['certs/*']
  
  s.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']

  s.add_development_dependency('test-unit')
end
