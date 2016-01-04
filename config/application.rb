require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hzshebao
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true, #generate a fixture for each model (using a Factory Girl factory, instead of an actual fixture)
        view_specs: false,  #skip generating view specs
        helper_specs: false, #skips generating specs for the helper files Rails generates with each controller
        routing_specs: false, #omits a spec file for your config/routes.rb file.
        controller_specs: true,
        request_specs: false #skips RSpec’s defaults for adding integration-level specs in spec/requests
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    End

  end
end
