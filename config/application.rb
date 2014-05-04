require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)

module Projets
  class Application < Rails::Application
    config.generators.helper = false
    config.generators.assets = false
  end
end
