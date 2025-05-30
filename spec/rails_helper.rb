# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner/active_record'
require 'capybara/rspec'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  # CI環境とローカル環境で異なる設定を使用
  if ENV['CI'] == 'true'
    # CI環境用設定
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
    )
  else
    # ローカルDocker環境用設定
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: ENV.fetch('SELENIUM_DRIVER_URL', 'http://selenium_chrome:4444/wd/hub'),
      options: options
    )
  end
end

Capybara.configure do |config|
  config.default_max_wait_time = 10  # CI環境対応で長めに設定
  config.automatic_reload = true
  config.match = :prefer_exact
  config.ignore_hidden_elements = true
  config.visible_text_only = true
  config.server_errors = []  # サーバーエラーを無視しない
end

# スクリーンショット設定
Capybara.save_path = Rails.root.join('tmp/capybara')

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :system

  # DatabaseCleaner設定
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(:suite) do
    # テスト終了後にキャッシュファイルを削除
    FileUtils.rm_rf(Dir[Rails.root.join('tmp/cache/**/*')])
    FileUtils.rm_rf(Dir[Rails.root.join('tmp/capybara/*')])
    FileUtils.rm_rf(Dir[Rails.root.join('tmp/screenshots/*')])
    # assets/sprocketsディレクトリを削除したい場合
    FileUtils.rm_rf(Dir[Rails.root.join('tmp/assets/sprockets/*')])
  end


  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # System Spec設定
  config.before(:each, type: :system) do
    if ENV['CI'] == 'true'
      # GitHub Actions環境ではローカルChromeを使用
      driven_by :selenium_chrome_headless do |driver_option|
        driver_option.add_argument('--no-sandbox')
        driver_option.add_argument('--disable-dev-shm-usage')
        driver_option.add_argument('--disable-gpu')
        driver_option.add_argument('--remote-debugging-port=9222')
        driver_option.add_argument('--window-size=1400,1400')
        # CI環境では少し長めの待機時間を設定
        driver_option.add_argument('--disable-web-security')
      end
      # CI環境専用の設定
      Capybara.default_max_wait_time = 15  # CI環境では更に長く
    else
      driven_by :remote_chrome
      Capybara.server_host = 'web'
      # Seleniumのログディレクトリをクリア
      FileUtils.rm_rf(Dir[Rails.root.join('tmp/selenium_logs/*')])
      # Capybaraのキャッシュをクリア
      FileUtils.rm_rf(Dir[Rails.root.join('tmp/capybara/*')])
    end
  end

  # スクリーンショット設定（デバッグ用）
  config.after(:each, type: :system) do |example|
    if example.exception
      save_path = "tmp/screenshots/#{example.full_description.gsub(' ', '_').gsub(/[^\w]/, '')}.png"
      begin
        page.save_screenshot(save_path)
        puts "Screenshot saved to #{save_path}"
      rescue Capybara::NotSupportedByDriverError => e
        puts "Could not save screenshot: #{e.message}"
      end
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
