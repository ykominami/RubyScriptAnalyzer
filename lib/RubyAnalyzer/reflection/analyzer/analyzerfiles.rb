require "RubyAnalyzer/utilmod2"

module RubyAnalyzer
	class Analyzer
		class AnalyzerFiles
			attr_accessor :analyzerfile

      include Utilmod2

			@names = [
				:target_class_list,
				:target_module_list,
				:target_instance_list,
				:exclude_class_list,
				:exclude_module_list,
				:exclude_instance_list,
				:exclude_const_list,
			]
			@analyzerfile_ = Struct.new("AnalyzerFilesx", *@names.map{|x| x})

			def self.get_analyzerfile
				@analyzerfile_
			end

			def initialize(target_classname_fname, target_modulename_fname, target_instancename_fname,
										exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname,
										exclude_constname_fname)
				@names = [
					[:target_class_list, target_classname_fname],
					[:target_module_list, target_modulename_fname],
					[:target_instance_list, target_instancename_fname],
					[:exclude_class_list, exclude_classname_fname],
					[:exclude_module_list, exclude_modulename_fname],
					[:exclude_instance_list, exclude_instancename_fname],
					[:exclude_const_list, exclude_constname_fname]
				]
				@analyzerfile = self.class.get_analyzerfile.new(*@names.map{|x| x[1]})
				@analyzerfile.members.map{ |list_key|
					list = File.readlines(@analyzerfile[list_key])
					list2 = list.map { |l| l.split("#").first }
					lines = Util.remove_empty_line(list2).map { |x| x.to_sym }
					@analyzerfile[list_key] = lines
				}
			end

			def sort_lists_x
				sort_lists!(@hs)
			end

			def print_lists_x
				print_lists(@hs)
			end
		end
	end
end