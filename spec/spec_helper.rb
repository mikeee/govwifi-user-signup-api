require 'rack/test'
require 'rspec'
require 'sequel'
require 'webmock/rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../app.rb', __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure { |c| c.include RSpecMixin }
