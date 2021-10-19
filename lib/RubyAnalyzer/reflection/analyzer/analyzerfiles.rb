require "RubyAnalyzer/utilmod2"

module RubyAnalyzer
	class Analyzer
		class AnalyzerFiles
      include Utilmod2

			def target_class_list
				@hs["target_class_list"]
			end

			def target_module_list
				@hs["target_module_list"]
			end

			def target_instance_list
				@hs["target_instance_list"]
			end

			def exclude_class_list
				@hs["exclude_class_list"]
			end

			def exclude_module_list
				@hs["exclude_module_list"]
			end

			def exclude_instance_list
				@hs["exclude_instance_list"]
			end

			def exclude_const_list
				@hs["exclude_const_list"]
			end

			def initialize(target_classname_fname, target_modulename_fname, target_instancename_fname,
										exclude_classname_fname, exclude_modulename_fname, exclude_instancename_fname,
										exclude_constname_fname)
				@hs = {}
				@names = [
					["target_class_list", target_classname_fname],
					["target_module_list", target_modulename_fname],
					["target_instance_list", target_instancename_fname],
					["exclude_class_list", exclude_classname_fname],
					["exclude_module_list", exclude_modulename_fname],
					["exclude_instance_list", exclude_instancename_fname],
					["exclude_const_list", exclude_constname_fname]
				]
				@names.map{ |list_key, fname|
					list = File.readlines(fname)
					list2 = list.map { |l| l.split("#").first }
					lines = Util.remove_empty_line(list2).map { |x| x.to_sym }
					@hs[list_key] = lines
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