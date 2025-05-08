# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner/active_record'
require 'capybara/rspec'

# System Spec用のリモートChromeドライバー設定
Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV['SELENIUM_DRIVER_URL'] || 'http://chrome:4444/wd/hub',
    options: options
  )
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
    driven_by :remote_chrome
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 3001  # 開発サーバーの3000と競合しないように
    Capybara.app_host = 'http://web:3001'  # webコンテナ内のサーバーに接続

  # Seleniumのログディレクトリをクリア
  FileUtils.rm_rf(Dir[Rails.root.join('tmp/selenium_logs/*')])
  
  # Capybaraのキャッシュをクリア
  FileUtils.rm_rf(Dir[Rails.root.join('tmp/capybara/*')])

  end
  
  # スクリーンショット設定（デバッグ用）
  config.after(:each, type: :system) do |example|
    if example.exception
      save_path = "tmp/screenshots/#{example.full_description.gsub(' ', '_').gsub(/[^\w]/, '')}.png"
      page.save_screenshot(save_path)
      puts "Screenshot saved to #{save_path}"
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end