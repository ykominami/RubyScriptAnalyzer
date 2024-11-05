#!/usr/bin/env ruby

require "bundler/setup"
require "rubyanalyzer2"

def analyzer_setup(target_classname_fname, target_modulename_fname, target_instancename_fname,
                   exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname,
                   exclude_constname_fname)
  RubyAnalyzer::Analyzer::AnalyzerFiles.new(target_classname_fname, target_modulename_fname, target_instancename_fname,
                                            exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname,
                                            exclude_constname_fname).analyzerfile
end

def analyzer_analyze(output_filepath, analyzerfiles, fname , fname2)
  analyzer = RubyAnalyzer::Analyzer.new(output_filepath, analyzerfiles, fname , fname2)
  #  p analyzer.instance_variables
  analyzer.init_items[:Object]
  #  p obj.instance_variables
  #  p obj
  #  p obj.instance_variables
  #  p obj.class_variables
  analyzer.analyze
  #  analyzer.print_all_class_related_info
end

if $PROGRAM_NAME == __FILE__
  output_filepath,
  target_classname_fname, target_modulename_fname, target_instancename_fname,
  exclude_classname_fname, exclude_modulename_fname, _,
  exclude_constname_fname, fname , fname2 = ARGV
  analyzer_setup(
    target_classname_fname, target_modulename_fname, target_instancename_fname,
    exclude_classname_fname, exclude_modulename_fname, exclude_constname_fname
  )
  analyzer_analyze(output_filepath, analyzerFiles, fname , fname2)
end
