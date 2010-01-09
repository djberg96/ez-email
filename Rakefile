require 'rake'
require 'rake/testtask'

desc "Cleanup .test-result files if present"
task :clean do
   rm_rf '.test-result' if File.exists?('.test-result')

   Dir.foreach(Dir.pwd){ |file|
      if File.directory?(file)
         Dir.chdir(file){
            rm_rf '.test-result' if File.exists?('.test-result')
         }
      end
   }
end

desc "Install the ez-email library (non-gem)"
task :install do
   dest = File.join(Config::CONFIG['sitelibdir'], 'file')
   Dir.mkdir(dest) unless File.exists? dest
   cp 'lib/file/find.rb', dest, :verbose => true
end

desc 'Build the ez-email gem'
task :gem do
   spec = eval(IO.read('ez-email.gemspec'))
   Gem::Builder.new(spec).build
end

desc "Install the ez-email package as a gem"
task :install_gem => [:gem] do
   file = Dir["*.gem"].first
   sh "gem install #{file}"
end

Rake::TestTask.new do |t|
   t.warning = true
   t.verbose = true
end
