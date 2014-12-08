require 'spree_model'

RSpec.configure do |config|
  config.color = true
  config.mock_with :rspec
  config.fail_fast = ENV['FAIL_FAST'] || false
end