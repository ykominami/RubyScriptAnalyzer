source "https://rubygems.org"

# Specify your gem's dependencies in RubyAnalyzer.gemspec
gemspec

# gem "bundler", "~> 2.0"
gem "aruba"

gem "bundler"
gem "rake", ">= 12.3.3"

group :test, optional: true do
  gem "rspec", "~> 3.0"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "byebug"
  gem "power_assert"
  gem "pry"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-stack_explorer"
end

group :development do
  gem 'yard', "~> 0.9.36"
end

gem "rb-readline"
