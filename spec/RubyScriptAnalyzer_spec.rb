require 'spec_helper'
require 'pathname'

RSpec.describe RubyScriptAnalyzer do
  it "has a version number" do
    expect(RubyScriptAnalyzer::VERSION).not_to be nil
  end

  context 'analyze' do
    before(:each) do
      home_dir = '/home/ykominami'
      dotfiles_dir = File.join(home_dir, "dotfiles")
      dotfiles_win_dir = File.join(dotfiles_dir, "win")
      repo_dir = File.join( home_dir , "repo-svn", "tecsgen-trunk")
      dotfiles_win_binr_dir = File.join( dotfiles_win_dir , "binr")
      parent_dir = Pathname.new(Dir.pwd).join("test2")
      fname = File.join(parent_dir , "rb2.rb" )

      fname2 = File.join(parent_dir , "r-a.rb")

      output_filepath = "output.yaml"
      target_classname_fname = "ra_target_classname.txt"
      target_classname_fname = File.join(parent_dir , target_classname_fname)
      target_modulename_fname = "ra_target_modulename.txt"
      target_modulename_fname = File.join(parent_dir , target_modulename_fname)
      target_instancename_fname = "ra_target_instancename.txt"
      target_instancename_fname = File.join(parent_dir , target_instancename_fname)
      # exclude_classname_fname = File.join( dotfiles_win_binr_dir, "ra_exclude_classname.txt")
      exclude_classname_fname = "ra_exclude_classname.txt"
      exclude_classname_fname = File.join(parent_dir , exclude_classname_fname)
      exclude_modulename_fname = "ra_exclude_modulename.txt"
      exclude_modulename_fname = File.join(parent_dir , exclude_modulename_fname)
      exclude_instancename_fname = "ra_exclude_instancename.txt"
      exclude_instancename_fname = File.join(parent_dir , exclude_instancename_fname)
      #
      exclude_constname_fname = "ra_exclude_constname.txt"
      exclude_constname_fname = File.join(parent_dir , exclude_constname_fname)
      #
      ENV['TECSPATH']='/home/ykominami/repo-svn/tecsgen-trunk/tecsgen/tecs'

      analyzerfiles = analyzer_setup(target_classname_fname, target_modulename_fname, target_instancename_fname, 
        exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname, exclude_constname_fname)
      #analyzer_analyze(output_filepath, analyzerfiles, fname , fname2)

#      analyzerfiles = RubyScriptAnalyzer::Analyzer::AnalyzerFiles.new( *af_names ).analyzerfile
      analyzer = RubyScriptAnalyzer::Analyzer.new(output_filepath, analyzerfiles, fname , fname2)
      @ret = analyzer.analyze
    end
    it 'format' , f:true do
      expect(@ret).to be true
    end
  end
end
