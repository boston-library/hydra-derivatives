#!/usr/bin/env rake

require "bundler/gem_tasks"

APP_ROOT="." # for jettywrapper
require 'jettywrapper'
# Dir.glob('tasks/*.rake').each { |r| import r }

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

load 'tasks/hydra_derivatives_spec.rake'

desc 'Spin up hydra-jetty and run specs'
task :ci => ['jetty:unzip'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

task :default => :ci
