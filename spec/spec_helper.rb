ENV['environment'] ||= 'test'
# - RSpec adds ./lib to the $LOAD_PATH
require 'pry'
require 'hydra/derivatives'
#Resque.inline = Rails.env.test?

require 'byebug' unless ENV['TRAVIS']

ActiveFedora::Base.logger = Logger.new(STDOUT)
ActiveFedora.config_options[:fedora_config_path] = File.open(File.expand_path('../fixtures/fedora.yml', __FILE__))
ActiveFedora.config_options[:solr_config_path] = File.open(File.expand_path('../fixtures/solr.yml', __FILE__))
RSpec.configure do |config|
end

$in_travis = !ENV['TRAVIS'].nil? && ENV['TRAVIS'] == 'true'
