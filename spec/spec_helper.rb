require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "rspec/autorun"

Dir[Rails.root.join("spec/{support,factories}/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
AWS.stub!

RSpec.configure do |config|
  include Factories
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  def stub_current_user(name: "Nathan", email: nil)
    if @controller
      email ||= "#{name.downcase}@example.com"
      @current_user = User.find_by(email: email) || create(:user, name: name, email: email)
      allow(@controller).to receive(:current_user).and_return(@current_user)
    end
  end

  def current_user
    @current_user
  end

  def json_response
    JSON.parse(response.body)
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start unless example.metadata[:no_db]
  end

  config.after(:each) do
    DatabaseCleaner.clean unless example.metadata[:no_db]
  end
end
