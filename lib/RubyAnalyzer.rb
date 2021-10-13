require "RubyAnalyzer/version"

module RubyAnalyzer
  class Error < StandardError; end
  # Your code goes here...

  require 'RubyAnalyzer/analyzer.rb'
  require 'RubyAnalyzer/ast.rb'
  require 'RubyAnalyzer/ast_inner.rb'
  require 'RubyAnalyzer/astitem.rb'
  require 'RubyAnalyzer/raenv.rb'
#  require 'RubyAnalyzer/raenv_test.rb'
  require 'RubyAnalyzer/hierspace.rb'
  require 'RubyAnalyzer/ident.rb'
  require 'RubyAnalyzer/inheritancespace.rb'
  require 'RubyAnalyzer/item.rb'
  require 'RubyAnalyzer/itembase.rb'
  require 'RubyAnalyzer/itemroot.rb'
  require 'RubyAnalyzer/listex.rb'
  require 'RubyAnalyzer/ns.rb'
#  require 'RubyAnalyzer/rubyanalyzer_test.rb'
  require 'RubyAnalyzer/rubysource.rb'
  require 'RubyAnalyzer/util.rb'

end

