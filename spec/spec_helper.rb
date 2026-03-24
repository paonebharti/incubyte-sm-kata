require 'rack/test'
require 'json'
require_relative '../lib/database'
require_relative '../lib/employee'
require_relative '../lib/salary_calculator'
require_relative '../lib/salary_metrics'
require_relative '../app'

ENV['APP_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    DB.run('DELETE FROM employees')
  end

  def app
    SalaryApp
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed
end
