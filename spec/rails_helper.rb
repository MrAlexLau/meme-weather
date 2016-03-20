require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  config.ignore_request do |request|
    URI(request.uri).host == '127.0.0.1'
  end

  config.filter_sensitive_data ('<GOOGLE_CSE_KEY>') { Rails.application.secrets.google_cse_api_key }
  config.filter_sensitive_data ('<GOOGLE_CSE_CX>') { Rails.application.secrets.google_cse_cx }
  config.filter_sensitive_data ('<OPEN_WEATHER_APP_ID>') { Rails.application.secrets.open_weather_app_id }
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.fail_fast = (ENV['RSPEC_FAIL_FAST'] == '1')
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.use_transactional_fixtures = false
end

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {

    # Create a unique logfile for PhantomJS that accepts JS console messages
    phantomjs_logger: File.open(File.join(Rails.root, 'log', "#{Rails.env}.poltergeist.log"), 'w'),

    timeout: 60, # default is 30

    # Do not turn this off. If a spec is generating JavaScript
    # errors in a manner that seems env-specific or unique to a
    # headless browser, it's probably one of the following:
    #
    # 1. Insufficient DB seeding - remember that the UI requires
    #    more comprehensive DB records to function properly. The
    #    `let_boilerplate` and `let_boilerplate!` helpers should
    #    take care of most of this for you.
    #
    # 2. Missing polyfill for PhantomJS - for example,
    #    Function#bind() is missing from most versions of PhantomJS,
    #    which is kind of bizarre, but outside the scope of this
    #    code comment.
    js_errors: true

  })
end

# migration check

ActiveRecord::Migration.maintain_test_schema!
