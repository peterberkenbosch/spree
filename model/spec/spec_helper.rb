if ENV["COVERAGE"]
  # Run Coverage report
  require 'simplecov'
  SimpleCov.start do
    # add_group 'Controllers', 'app/controllers'
    # add_group 'Helpers', 'app/helpers'
    # add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'lib/models'
    # add_group 'Views', 'app/views'
    # add_group 'Jobs', 'app/jobs'
    add_group 'Libraries', 'lib'
  end
end

require 'spree_model'

# require testing support
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.mock_with :rspec
  config.fail_fast = ENV['FAIL_FAST'] || false
end
