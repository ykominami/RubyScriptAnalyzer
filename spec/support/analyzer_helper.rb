require "Rubyscriptanalyzer2.rb"
require 'pathname'

module AnalyzerHelper
	def test_setup(test_data_dir, file_names)
		test_data_pn = Pathname.new(test_data_dir)
		# file_names = %W!rb2.rb r-a.rb output.yaml!
		file_names.map{ |path| test_data_pn.join(path) }
	end

	def analyzer_setup(target_classname_fname, target_modulename_fname, target_instancename_fname,
		exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, 
		exclude_constname_fname)
		RubyScriptAnalyzer::Analyzer::AnalyzerFiles.new(target_classname_fname, target_modulename_fname, target_instancename_fname,
		exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, 
		exclude_constname_fname).analyzerfile
	end

	def create_analyzer(output_filepath, analyzerfiles, fname , fname2)
		analyzer = RubyScriptAnalyzer::Analyzer.new(output_filepath, analyzerfiles, fname , fname2)
	end
end
