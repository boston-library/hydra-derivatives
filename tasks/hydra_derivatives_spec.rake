require 'jettywrapper'
desc "Run Specs for with jetty wrapper locally"
namespace :hydra_derivatives do
  task :jetty_spec do
    jetty_params = Jettywrapper.load_config
    puts "Jetty Params are .....#{jetty_params}"
    error = Jettywrapper.wrap(jetty_params) do
      Rake::Task['spec'].invoke
    end
    raise "test failures: #{error}" if error
  end
end
