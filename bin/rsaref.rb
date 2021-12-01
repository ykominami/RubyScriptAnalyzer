#!/usr/bin/env ruby

require "bundler/setup"
require "Rubyscriptanalyzer2.rb"

def analyzer_setup(target_classname_fname, target_modulename_fname, target_instancename_fname,
                    exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, 
                    exclude_constname_fname)
  RubyScriptAnalyzer::Analyzer::AnalyzerFiles.new(target_classname_fname, target_modulename_fname, target_instancename_fname,
                    exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, 
                    exclude_constname_fname).analyzerfile
end

def analyzer_analyze(output_filepath, analyzerfiles, fname , fname2)
  analyzer = RubyScriptAnalyzer::Analyzer.new(output_filepath, analyzerfiles, fname , fname2)
#  p analyzer.instance_variables
#  obj = analyzer.init_items[:Object]
#  p obj.instance_variables
#  p obj
#  p obj.instance_variables
#  p obj.class_variables
  analyzer.analyze
#  analyzer.print_all_class_related_info
end

if $0 == __FILE__
  output_filepath, 
  target_classname_fname, target_modulename_fname, target_instancename_fname, 
  exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, 
  exclude_constname_fname, fname , fname2 = ARGV
  analyzerfiles = analyzer_setup(
    target_classname_fname, target_modulename_fname, target_instancename_fname, 
    exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, 
    exclude_constname_fname)
  analyzer_analyze(output_filepath, analyzerfiles, fname , fname2)
end
