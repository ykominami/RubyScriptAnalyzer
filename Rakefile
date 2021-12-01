require "bundler/gem_tasks"
require "rspec/core/rake_task"

rt = RSpec::Core::RakeTask.new(:spec)
#rt.pattern = "spec/\*\*\{,/\*/\*\*\}/\*_spec.rb"
#rt.exclude_pattern =  "spec/RubyScriptAnalyzer_cli_spec.rb"
#rt.exclude_pattern =  "spec/RubyScriptAnalyzer_cli_spec.rb"
#rt.default_pattern = "spec/\*\*\{,/\*/\*\*\}/\*_spec.rb"
rt.default_pattern = "\*\*\{,/\*/\*\*\}/\*_spec.rb"

task :default => :spec
