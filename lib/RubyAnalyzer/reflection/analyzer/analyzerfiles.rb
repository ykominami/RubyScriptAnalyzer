require "RubyAnalyzer/utilmod2"

module RubyAnalyzer
	class Analyzer
		class AnalyzerFiles
			attr_accessor :target_class_list, :target_module_list,
										:exclude_class_list, :exclude_module_list,
										:exclude_instance_list, :exclude_const_list
			include Utilmod2

			def initialize(target_classname_fname, target_modulename_fname, target_instancename_fname,
										exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname,
										exclude_constname_fname)
				@fnames_lists = []
				#
				@target_class_list = []
				@fnames_lists << Tuple.new(target_classname_fname, :@target_class_list)
				@target_module_list = []
				@fnames_lists << Tuple.new(target_modulename_fname, :@target_module_list)
				@target_instance_list = []
				@fnames_lists << Tuple.new(target_instancename_fname, :@target_instance_list)
				#
				@exclude_class_list = []
				@fnames_lists << Tuple.new(exclude_classname_fname, :@exclude_class_list)
				@exclude_module_list = []
				@fnames_lists << Tuple.new(exclude_modulename_fname, :@exclude_module_list)
				@exclude_instance_list = []
				@fnames_lists << Tuple.new(exclude_instancename_fname, :@exclude_instance_list)
				@exclude_const_list = []
				@fnames_lists << Tuple.new(exclude_constname_fname, :@exclude_const_list)

				@fnames_lists.map{ |t|
					list = File.readlines(t.l)
					list2 = list.map { |l| l.split("#").first }
					lines = Util.remove_empty_line(list2).map { |x| x.to_sym }
					self.instance_variable_set(t.r , lines)
				}
				@sym_varnames = @fnames_lists.map{ |t| t.r }
			end

			def sort_lists_x
				sort_lists_t(@sym_varnames)
			end

			def print_lists_x
				print_lists(@sym_varnames)
			end
		end
	end
end