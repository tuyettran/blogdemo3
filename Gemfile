source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bootstrap-kaminari-views"
gem "bootstrap-sass", "~> 3.3.7"
gem "cancancan"
gem "carrierwave", "1.1.0"
gem "ckeditor", github: "galetahub/ckeditor"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "devise"
gem "faker"
gem "whenever", :require => false
gem "fog"
gem "foundation-rails"
gem "i18n-js", "3.0.0"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "kaminari"
gem "mini_magick", "4.7.0"
gem "mysql2"
gem "sidekiq"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.2"
gem "rails_admin"
gem "rails_admin_toggleable"
gem "sass-rails", "~> 5.0"
gem "social-share-button"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "autoprefixer-rails"
  gem "better_errors"
  gem "brakeman", require: false
  gem "bundler-audit"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "database_cleaner"
  gem "eslint-rails"
  gem "eslint-rails"
  gem "factory_girl_rails"
  gem "guard-rspec", require: false
  gem "jshint"
  gem "railroady"
  gem "rails_best_practices"
  gem "reek"
  gem "rspec"
  gem "rspec-collection_matchers"
  gem "rspec-rails", "~> 3.5"
  gem "rubocop", "~> 0.35.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "scss_lint_reporter_checkstyle", require: false
  gem "selenium-webdriver"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-json"
  gem "simplecov-rcov", require: false
end

group :production do
  gem "pg", "0.18.4"
  gem "rails_12factor", "0.0.2"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
