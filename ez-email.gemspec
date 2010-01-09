require 'rubygems'

Gem::Specification.new do |s|
   s.name        = 'ez-email'
   s.version     = '0.1.1'
   s.license     = 'Artistic 2.0'
   s.summary     = 'Really easy emails'
   s.description = 'A very simple interface for sending email'
   s.author      = 'Daniel Berger'
   s.email       = 'djberg96@gmail.com'
   s.homepage    = 'http://www.rubyforge.org/projects/shards'
   s.files       = Dir['**/*'].reject{ |f| f.include?('CVS') }
   s.test_file	  = 'test/test_ez_email.rb'
   s.has_rdoc    = true
   
   s.rubyforge_project = 'shards'
   s.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']
end
