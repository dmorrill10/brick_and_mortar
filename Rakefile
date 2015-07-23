require 'bundler/gem_tasks'
require 'rake'
require 'rake/clean'
require 'rake/testtask'

require_relative 'lib/mortar/version'

desc 'Test gem'
task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "lib" << 'spec/support'
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = false
  t.warning = false
end

