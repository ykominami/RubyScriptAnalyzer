require 'rubyscriptanalyzer2.rb'
require 'pathname'
require 'aruba/rspec'

RSpec.describe 'command-line', type: :aruba do
	before(:each) {
		filenames = %W!
			output.yaml
			ra_target_classname.txt ra_target_modulename.txt ra_target_instancename.txt
			ra_exclude_classname.txt ra_exclude_modulename.txt ra_exclude_instancename.txt
			ra_exclude_constname.txt
			rb2.rb r-a.rb!
		parent_pn = Pathname.new(__dir__).parent
		test_data_pn = parent_pn.join("test2")
		cmd_pn = parent_pn.join("bin", "rubyscriptanalyzer2.rb")
		@cmd = %!#{cmd_pn} #{test_setup(test_data_pn, filenames).join(" ")}!
	}

	describe '#analyze' do
		context 'when the path to the ruby script is not valid' do
			before(:each) do
				run_command(@cmd)
			end
			it 'success' do
				expect(last_command_started).to be_successfully_executed
			end
		end
=begin
		context 'when the path to the ruby script is valid' do
			it 'returns the number of lines' do
				expect(ruby_script_analyzer.analyze(path_to_ruby_script)).to eq(5)
			end
		end
=end
	end
end
