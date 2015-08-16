begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActiveJob Query'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'

ADAPTERS = %w(sidekiq resque) #delayed_job inline qu que queue_classic sneakers sucker_punch backburner

def run_without_aborting(*tasks)
  errors = []

  tasks.each do |task|
    begin
      Rake::Task[task].invoke
    rescue Exception
      errors << task
    end
  end

  abort "Errors running #{errors.join(', ')}" if errors.any?
end

desc 'Run all adapter tests'
task :test do
  tasks = ADAPTERS.map{|a| "test:#{a}" }
  run_without_aborting(*tasks)
end

namespace :test do
  ADAPTERS.each do |adapter|
    Rake::TestTask.new(adapter) do |t|
      t.libs << 'lib'
      t.libs << 'test'
      t.pattern = 'test/**/*_test.rb'
      t.verbose = false
    end
    namespace adapter do
      task(:env) { ENV['AJADAPTER'] = adapter }
    end
    task adapter => "#{adapter}:env"
  end
end

task default: :test
