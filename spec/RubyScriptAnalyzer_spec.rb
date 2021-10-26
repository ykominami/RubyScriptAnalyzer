require 'spec_helper'
require 'pathname'

RSpec.describe RubyScriptAnalyzer do
  it "has a version number" do
    expect(RubyScriptAnalyzer::VERSION).not_to be nil
  end

  context 'analyze' do
    before(:each) do

      analyzerfiles = RubyScriptAnalyzer::Analyzer::AnalyzerFiles.new( *af_names ).analyzerfile
      analyzer = RubyScriptAnalyzer::Analyzer.new(output_filepath, analyzerfiles, fname , fname2)
      @ret = analyzer.analyze
    end
    it 'format' , f:true do
      expect(@ret).to be true
    end
  end
end
