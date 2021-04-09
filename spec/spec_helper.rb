$LOAD_PATH.unshift File.expand_path(__dir__)
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "rspec"
require "rack/test"
require "webmock/rspec"
require "omniauth"
require "omniauth-oauth2"
require "pry-byebug"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.extend OmniAuth::Test::StrategyMacros, type: :strategy
  config.include Rack::Test::Methods
  config.include WebMock::API
end
