require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run tests'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/spec_*.rb']
  t.options = '-v'
end

desc 'Run Rubocop on the gem'
Rubocop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/*.rb', 'test/*.rb']
  task.fail_on_error = true
end

desc 'Run travis-lint on .travis.yml'
task :travislint do
  fail 'There is an issue with your .travis.yml' unless system('travis-lint')
end

task default: [:test, :travislint, :rubocop, :build, :install]
