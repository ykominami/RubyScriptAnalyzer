require "RubyAnalyzer/version"

module RubyAnalyzer
  class Error < StandardError; end
  # Your code goes here...

  require 'RubyAnalyzer/analyzer'
  require 'RubyAnalyzer/ast'
  require 'RubyAnalyzer/ast_inner'
  require 'RubyAnalyzer/astitem'
  require 'RubyAnalyzer/raenv'
  #  require 'RubyAnalyzer/raenv_test.rb'
  require 'RubyAnalyzer/hierspace'
  require 'RubyAnalyzer/ident'
  require 'RubyAnalyzer/inheritancespace'
  require 'RubyAnalyzer/item'
  require 'RubyAnalyzer/itembase'
  require 'RubyAnalyzer/itemroot'
  require 'RubyAnalyzer/listex'
  require 'RubyAnalyzer/ns'
  #  require 'RubyAnalyzer/rubyanalyzer_test.rb'
  require 'RubyAnalyzer/rubysource'
  require 'RubyAnalyzer/util'

end
