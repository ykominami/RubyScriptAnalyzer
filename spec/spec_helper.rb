# frozen_string_literal: true

require 'pathname'
require 'bundler/setup'
require 'Rubyscriptanalyzer2'


$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

if RUBY_VERSION < '1.9.3'
  ::Dir.glob(::File.expand_path('support/**/*.rb', __dir__)).each do |f|
    require File.join(File.dirname(f), File.basename(f, '.rb'))
  end
else
  ::Dir.glob(::File.expand_path('support/*.rb', __dir__)).each { |f| require_relative f }
  ::Dir.glob(::File.expand_path('support/**/*.rb', __dir__)).each { |f| require_relative f; p f }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  #  config.filter_run_when_matching(focus: true)

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

include  AnalyzerHelper
