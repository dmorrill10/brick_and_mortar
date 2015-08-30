require 'bundler/gem_tasks'
require 'rake'
require 'rake/clean'

require_relative 'lib/mortar/version'

desc 'Test gem'
task default: [:test]

task :test do
  libs = ['lib', 'spec/support']
  test_files = FileList['spec/**/*_spec.rb']

  test_files.each do |test_file|
    includes = libs.map { |l| "-I#{l}"}.join ' '
    sh "ruby #{includes} #{test_file}"
  end
end
