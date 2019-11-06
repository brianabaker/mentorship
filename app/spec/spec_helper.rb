require 'rack/test'
require 'rspec'
require 'pry'
require 'factory_bot'
binding.pry
ENV['RACK_ENV'] = 'test'

FactoryBot.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryBot.find_definitions

# A comment
module RSpecMixin
  include Rack::Test::Methods

  def app
    described_class
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.include FactoryBot::Syntax::Methods
end
